output "publicroutetableID" {
  value = "${aws_route_table.public_RT.id}"
}

output "privateroutetableID" {
  value = "${aws_route_table.private_RT.id}"
}