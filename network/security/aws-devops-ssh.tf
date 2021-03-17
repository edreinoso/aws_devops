data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "terraform-state-er"
    key    = "env:/dev/aws_devops/network.tfstate"
    region = "us-east-1"
  }
}


# AWS_DEVOPS SG
resource "aws_security_group" "devops-sg" {
  name        = "${var.devops-sg-name-pub}-${terraform.workspace}-ssh"
  description = "Security group for devops in ${terraform.workspace} environment"
  vpc_id      = element(data.terraform_remote_state.vpc.outputs.vpc-id, 1)

  tags = {
    Name          = "${var.devops-sg-name-pub}-${terraform.workspace}-ssh"
    Template      = var.template
    Environment   = terraform.workspace
    Creation_Date = var.created-on
  }
}

resource "aws_security_group_rule" "devops-sg-rule-01" {
  # count     = "${length(var.cidr-blocks)}"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = split(",", var.ips)
  security_group_id = aws_security_group.devops-sg.id
}

resource "aws_security_group_rule" "devops-sg-rule-egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.devops-sg.id
}