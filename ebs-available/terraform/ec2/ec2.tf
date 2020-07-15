data "terraform_remote_state" "security" {
  backend = "s3"
  config = {
    bucket = "terraform-state-er"
    key    = "env:/dev/standard-1/security-terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "terraform-state-er"
    key    = "env:/dev/standard-1/network-terraform.tfstate"
    region = "us-east-1"
  }
}

module "ec2" {
  source             = "/Users/elchoco/aws/terraform_infrastructure_as_code//modules/compute/ec2"
  ami         = "${var.ami}"
  instance-type      = "${var.instance-type}"
  subnet-ids         = "${element(
    element(data.terraform_remote_state.vpc.outputs.pub-subnet-2-id, 1),
    1,
  )}"
  ec2-name           = "${var.ec2-name}"
  template           = "${var.template}"
  public-ip          = "${var.public-ip-association["yes"]}"
  instance-role      = "${var.instance-role}"
  sourceCheck        = "${var.source-check["enable"]}"
  key-name           = "${var.key-name["public"]}"
  security-group-ids = "${split(",", data.terraform_remote_state.security.outputs.public-sg-id)}"
  created-on = "${var.creation_date}"
  application = "${var.application}"
  purpose = "${var.purpose}"
}