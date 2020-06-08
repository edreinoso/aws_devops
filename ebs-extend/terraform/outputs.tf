output "id" {
  value = "${aws_instance.ec2.*.id}"
}