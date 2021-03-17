output "target-arn" {
  value = "${aws_lb_target_group.target-group.arn}"
}

output "tg-arn-suffix" {
  value = "${aws_lb_target_group.target-group.arn_suffix}"
}