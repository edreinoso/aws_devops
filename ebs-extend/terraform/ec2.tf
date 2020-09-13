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

# data "aws_ami" "custom_ami" {
#   filter {
#     name   = "name"
#     values = ["${var.custom-ami}"]
#   }
#   owners = ["self"]
# }

resource "aws_instance" "ec2" {
  # count         = "${length(var.volume-size)}"
  ami           = "${var.ami}"
  instance_type = "${var.type}"
  key_name      = "${var.keys}"
  subnet_id = "${element(
    element(data.terraform_remote_state.vpc.outputs.pub-subnet-1-id, 1),
    1,
  )}"
  vpc_security_group_ids      = "${split(",", data.terraform_remote_state.security.outputs.aws-devops-sg-id)}"
  iam_instance_profile        = "${var.instance-role}"
  associate_public_ip_address = "${var.public-ip == "" ? false : true}"
  source_dest_check           = "${var.sourceCheck == "" ? false : true}"
  # user_data                   = "${var.user-data}"


  tags = {
    Name          = "${var.ec2-name}"
    Environment   = "${terraform.workspace}"
    Template      = "${var.template}"
    Application   = "${var.application}"
    Purpose       = "${var.purpose}"
    Creation_Date = "${var.created-on}"
  }

  # ebs_block_device {
  #   device_name = "${var.ec2-name}"
  #   volume_size = "${split(",", var.volume-size)}"
  # }
}
