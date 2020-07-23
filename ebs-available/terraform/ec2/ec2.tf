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

module "ec2-no-ebs" {
  source        = "/Users/elchoco/aws/terraform_infrastructure_as_code/modules/compute/ec2"
  ami           = "${var.ami}"
  instance-type = "${var.instance-type}"
  subnet-ids = "${element(
    element(data.terraform_remote_state.vpc.outputs.pub-subnet-2-id, 1),
    1,
  )}"
  ec2-name           = "${var.ec2-name}"
  template           = "${var.template}"
  public-ip          = "${var.public-ip-association["yes"]}"
  instance-role      = "${var.instance-role}"
  sourceCheck        = "${var.source-check["enable"]}"
  key-name           = "${var.key-name["public"]}"
  security-group-ids = "${split(",", data.terraform_remote_state.security.outputs.aws-devops-sg-id)}"
  created-on         = "${var.creation_date}"
  application        = "${var.application}"
  purpose            = "${var.purpose}"
}

module "ec2-with-ebs" {
  source        = "/Users/elchoco/aws/terraform_infrastructure_as_code/modules/compute/ec2"
  ami           = "${var.ami}"
  instance-type = "${var.instance-type}"
  subnet-ids = "${element(
    element(data.terraform_remote_state.vpc.outputs.pub-subnet-1-id, 1),
    1,
  )}"
  ec2-name           = "${var.ec2-name}-2"
  template           = "${var.template}"
  public-ip          = "${var.public-ip-association["yes"]}"
  instance-role      = "${var.instance-role}"
  sourceCheck        = "${var.source-check["enable"]}"
  key-name           = "${var.key-name["public"]}"
  security-group-ids = "${split(",", data.terraform_remote_state.security.outputs.aws-devops-sg-id)}"
  created-on         = "${var.creation_date}"
  application        = "${var.application}"
  purpose            = "${var.purpose}"

  ebs_block_device = [
    {
      device_name = "/dev/sdl"
      volume_size = 5
    },
    {
      device_name = "/dev/sdk"
      volume_size = 10
    },
  ]
}
