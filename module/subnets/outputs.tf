output "subnet1" {
  value = "${aws_subnet.subnet1.id}"
}

output "subnet2" {
  value = "${aws_subnet.subnet2.id}"
}

output "privatesubnet" {
  value = "${aws_subnet.privatesubnet.id}"
}
