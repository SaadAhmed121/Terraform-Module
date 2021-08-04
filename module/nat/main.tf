resource "aws_nat_gateway" "nat" {
    allocation_id = "${var.eip}"
    subnet_id = "${var.subnet}"
    depends_on = [var.igw]

    tags = {
        Name = "Saad-NAT"
    }
} 