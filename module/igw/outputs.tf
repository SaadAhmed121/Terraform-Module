output "igw" {
  value = "${aws_internet_gateway.intgw.id}"
}

output "igww" {
  value = [aws_internet_gateway.intgw]
}

