output "subnet-id" {
  value = "${aws_subnet.subnet.*.id}"
}
