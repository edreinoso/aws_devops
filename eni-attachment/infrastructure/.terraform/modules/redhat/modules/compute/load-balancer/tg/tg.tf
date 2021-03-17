###### Target Groups #####
resource "aws_lb_target_group" "target-group" {
  name                 = var.elb-tg-name
  port                 = var.tg-port
  protocol             = var.tg-protocol
  target_type          = var.tg-target-type
  vpc_id               = var.vpc-id
  deregistration_delay = var.deregistration

  health_check {
    path     = var.path
    port     = var.tg-port
    protocol = var.tg-protocol
  }

  tags = var.tags
}
