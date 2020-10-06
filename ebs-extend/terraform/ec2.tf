data "terraform_remote_state" "security" {
  backend = "s3"
  config = {
    bucket = "terraform-state-er"
    key    = "env:/dev/aws_devops/security.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "terraform-state-er"
    key    = "env:/dev/aws_devops/network.tfstate"
    region = "us-east-1"
  }
}

module "ec2" {
  source             = "/Users/elchoco/aws/terraform_infrastructure_as_code/modules/compute/ec2"
  ami                = "${var.ami}"
  instance-type      = "${var.type}"
  security-group-ids = "${split(",", data.terraform_remote_state.security.outputs.aws-devops-sg-id)}"
  subnet-ids = "${element(
    element(data.terraform_remote_state.vpc.outputs.pub-subnet-1-id, 1),
    1,
  )}"
  instance-role = "${var.instance-role}"
  public-ip     = "${var.public-ip}"
  key-name      = "${var.keys}"

  tags = {
    Name          = "${var.ec2-name}"
    Environment   = "${terraform.workspace}"
    Template      = "${var.template}"
    Application   = "${var.application}"
    Purpose       = "${var.purpose}"
    Creation_Date = "${var.created-on}"
  }
}
