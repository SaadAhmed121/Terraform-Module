resource "aws_vpc" "saad-vpc" {
  cidr_block = "${var.vpc_cidr}"
  instance_tenancy = "default"
  tags = {
        Name = "Saad-VPC"
    }
}

