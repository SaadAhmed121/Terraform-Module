resource "aws_route_table_association" "public_subnet" {
    subnet_id = "${var.publicsubnetid1}"
    route_table_id = "${var.publicRT}"
}

resource "aws_route_table_association" "public_subnet2" {
    subnet_id = "${var.publicsubnetid2}"
    route_table_id = "${var.publicRT}"
}


resource "aws_route_table_association" "private_subnet" {
    subnet_id = "${var.privatesubnetid}"
    route_table_id = "${var.private_RT}"
}
