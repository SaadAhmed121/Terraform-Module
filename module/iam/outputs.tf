output "iam_profile" {
  value = "${aws_iam_instance_profile.test_profile.name}"
}