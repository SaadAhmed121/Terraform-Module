resource "aws_subnet" "subnet1" {
  availability_zone = "${var.subnetaz1}"
  vpc_id = "${var.vpc_id}"
  cidr_block = "${var.subnet1_cidr}"
  

  tags = {
    Name: "Saad-Public-Subnet-1"
  }
}

resource "aws_subnet" "subnet2" {
  availability_zone = "${var.subnetaz2}"
  vpc_id = "${var.vpc_id}"
  cidr_block = "${var.subnet2_cidr}"
  

  tags = {
    Name: "Saad-Public-Subnet-2"
  }
}

resource "aws_subnet" "privatesubnet" {
  availability_zone = "${var.subnetaz3}"
  vpc_id = "${var.vpc_id}"
  cidr_block = "${var.privatesubnet_cidr}"
  

  tags = {
    Name: "Saad-privatesubnet"
  }
}