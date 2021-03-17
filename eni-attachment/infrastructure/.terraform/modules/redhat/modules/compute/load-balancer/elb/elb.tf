resource "aws_lb" "elb" {
  name               = var.elb-name
  internal           = var.internal-elb
  load_balancer_type = var.elb-type
  security_groups    = var.security-group
  subnets            = var.subnet-ids
  
  access_logs {
    bucket  = var.bucket-name
    prefix  = ""
    enabled = true
  }

  tags = var.tags

  # tags = merge(
  #   var.tags,
  #   var.lb_tags,
  # )
}
