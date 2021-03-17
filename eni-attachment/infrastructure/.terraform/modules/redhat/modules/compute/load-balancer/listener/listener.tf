###### Listeners #####
resource "aws_lb_listener" "listener" {
  load_balancer_arn = var.elb-arn
  port              = var.listener-port
  protocol          = var.listener-protocol
  ssl_policy        = var.ssl-policy
  certificate_arn   = var.certificate-arn
  
  default_action {
    target_group_arn = var.target-group-arn
    type             = "forward"
  }
}
