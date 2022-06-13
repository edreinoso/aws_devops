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

module "ec2-ebs-1" {
  source = "github.com/edreinoso/terraform_infrastructure_as_code/modules/compute/ec2"
  ami    = "${var.ami}"
  subnet-ids = "${element(
    element(data.terraform_remote_state.vpc.outputs.pub-subnet-2-id, 1),
    1,
  )}"
  instance-type      = "${var.instance-type}"
  public-ip          = "${var.public-ip-association["yes"]}"
  instance-role      = "${var.instance-role}"
  sourceCheck        = "${var.source-check["enable"]}"
  key-name           = "${var.key-name["public"]}"
  security-group-ids = "${split(",", data.terraform_remote_state.security.outputs.aws-devops-sg-id)}"
  tags = {
    Name          = "ebs_encryption_2_b"
    Template      = "aws_devops"
    Environment   = "none"
    Application   = "ebs_encrypt"
    Purpose       = "Testing ebs encryption"
    Creation_Date = "Jan_1_2021"
  }

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

module "ec2-ebs-2" {
  source = "github.com/edreinoso/terraform_infrastructure_as_code/modules/compute/ec2"
  ami    = "${var.ami}"
  subnet-ids = "${element(
    element(data.terraform_remote_state.vpc.outputs.pub-subnet-2-id, 1),
    1,
  )}"
  instance-type      = "${var.instance-type}"
  public-ip          = "${var.public-ip-association["yes"]}"
  instance-role      = "${var.instance-role}"
  sourceCheck        = "${var.source-check["enable"]}"
  key-name           = "${var.key-name["public"]}"
  security-group-ids = "${split(",", data.terraform_remote_state.security.outputs.aws-devops-sg-id)}"
  tags = {
    Name          = "ebs_encryption_1_b"
    Template      = "aws_devops"
    Environment   = "none"
    Application   = "ebs_encrypt"
    Purpose       = "Testing ebs encryption"
    Creation_Date = "Jan_1_2021"
  }

  ebs_block_device = [
    {
      device_name = "/dev/sdl"
      volume_size = 15
    },
    {
      device_name = "/dev/sdk"
      volume_size = 20
    },
  ]
}

module "ec2-ebs-3" {
  source = "github.com/edreinoso/terraform_infrastructure_as_code/modules/compute/ec2"
  ami    = "${var.ami}"
  subnet-ids = "${element(
    element(data.terraform_remote_state.vpc.outputs.pub-subnet-1-id, 1),
    1,
  )}"
  instance-type      = "${var.instance-type}"
  public-ip          = "${var.public-ip-association["yes"]}"
  instance-role      = "${var.instance-role}"
  sourceCheck        = "${var.source-check["enable"]}"
  key-name           = "${var.key-name["public"]}"
  security-group-ids = "${split(",", data.terraform_remote_state.security.outputs.aws-devops-sg-id)}"
  tags = {
    Name          = "ebs_encryption_1_a"
    Template      = "aws_devops"
    Environment   = "${terraform.workspace}"
    Application   = "ebs_encrypt"
    Purpose       = "Testing ebs encryption"
    Creation_Date = "Jan_1_2021"
  }

  ebs_block_device = [
    {
      device_name = "/dev/sdl"
      volume_size = 25
    },
    {
      device_name = "/dev/sdk"
      volume_size = 30
    },
  ]
}
