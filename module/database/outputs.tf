output "DB_IP" {
  value = "${aws_instance.database_instance.public_ip}"
}

