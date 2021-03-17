##### Target Groups Attachment #####
resource "aws_lb_target_group_attachment" "target-group" {
  target_group_arn = var.target-group-arn
  target_id        = var.tg-id
  port             = var.port
}
