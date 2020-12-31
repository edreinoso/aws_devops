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
  source        = "/Users/elchoco/aws/terraform_infrastructure_as_code/modules/compute/ec2"
  ami           = "${var.ami}"
  instance-type = "${var.instance-type}"
  subnet-ids = "${element(
    element(data.terraform_remote_state.vpc.outputs.pub-subnet-2-id, 1),
    1,
  )}"
  public-ip          = "${var.public-ip-association["yes"]}"
  instance-role      = "${var.instance-role}"
  sourceCheck        = "${var.source-check["enable"]}"
  key-name           = "${var.key-name["public"]}"
  security-group-ids = "${split(",", data.terraform_remote_state.security.outputs.aws-devops-sg-id)}"
  tags = {
    Name          = "auto_amis_az_b"
    Template      = "devops"
    Environment   = "${terraform.workspace}"
    Application   = "auto ami automation"
    Purpose       = "launching instance to test ami creation"
    Creation_Date = "Dec 18th"
  }
}
