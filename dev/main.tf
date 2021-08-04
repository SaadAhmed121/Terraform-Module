provider "aws" {
    access_key = "*****"
    secret_key = "****"
    region = "us-east-1"
}


terraform {
  backend "s3" {
    bucket = "saad-terraform-tfstate"
    key    = "terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform_lock"

  }
}

module "vpc_module" {
    source = "/home/saad/Documents/Terraform-Module/module/vpc"
}

module "subnets" {
    source = "/home/saad/Documents/Terraform-Module/module/subnets"
    vpc_id =  "${module.vpc_module.vpc_id}"
}

module "IGW" {
    source = "/home/saad/Documents/Terraform-Module/module/igw"
    vpc_id =  "${module.vpc_module.vpc_id}"
}

module "EIP" {
    source = "/home/saad/Documents/Terraform-Module/module/eip"
    igw =  "${module.IGW.igww}"
}


module "NAT" {
    source = "/home/saad/Documents/Terraform-Module/module/nat"
    subnet =  "${module.subnets.subnet1}"
    igw = "${module.IGW.igww}"
    eip = "${module.EIP.eip}"
}

module "SG" {
    source = "/home/saad/Documents/Terraform-Module/module/sg"
    vpc_id =  "${module.vpc_module.vpc_id}"
}

module "SG_DB" {
    source = "/home/saad/Documents/Terraform-Module/module/sg_database"
    vpc_id =  "${module.vpc_module.vpc_id}"
}

module "IAM" {
    source = "/home/saad/Documents/Terraform-Module/module/iam"
    
}

module "route_table" {
    source = "/home/saad/Documents/Terraform-Module/module/routetable"
    vpc_id =  "${module.vpc_module.vpc_id}"
    igw =  "${module.IGW.igw}"
    nat = "${module.NAT.nat}"

}

module "route_table_association" {
    source = "/home/saad/Documents/Terraform-Module/module/routetableconf"
    publicsubnetid1 = "${module.subnets.subnet1}"
    publicsubnetid2 = "${module.subnets.subnet2}"
    privatesubnetid = "${module.subnets.privatesubnet}"
    publicRT = "${module.route_table.publicroutetableID}"
    private_RT = "${module.route_table.privateroutetableID}"
}

module "DB_instance" {
    source = "/home/saad/Documents/Terraform-Module/module/database"
    subnet = "${module.subnets.subnet1}"
    iam = "${module.IAM.iam_profile}"
    sg = "${module.SG_DB.sg}"
}

# module "WEB_instance" {
#     source = "/home/saad/Documents/Terraform-Module/module/web"
#     subnet = "${module.subnets.subnet1}"
#     iam = "${module.IAM.iam_profile}"
#     sg = "${module.SG.sg}"
#     db_ip = "${module.DB_instance.DB_IP}"
# }

module "Autoscaling" {
    source = "/home/saad/Documents/Terraform-Module/module/autoscaling"
    subnet = "${module.subnets.subnet1}"
    subnet2 = "${module.subnets.subnet2}"
    iam = "${module.IAM.iam_profile}"
    sg = "${module.SG.sg}"
    DB_IP = "${module.DB_instance.DB_IP}"
    LB = "${module.LoadBalancer.LB}"
}

module "LoadBalancer" {
    source = "/home/saad/Documents/Terraform-Module/module/LB"
    subnet = "${module.subnets.subnet1}"
    subnet2 = "${module.subnets.subnet2}"
    sg = "${module.SG.sg}"
    
  
}