resource "aws_internet_gateway" "intgw"{
    vpc_id = "${var.vpc_id}"

    tags = {

        Name: "Saad-IGW"
    }
 
}