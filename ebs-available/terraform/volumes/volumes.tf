data "terraform_remote_state" "ec2" {
  backend = "s3"
  config = {
    bucket = "terraform-state-er"
    key    = "env:/dev/ebs-available/ec2.tfstate"
    region = "us-east-1"
  }
}

module "volume" {
  source    = "/Users/elchoco/aws/terraform_infrastructure_as_code/modules/compute/volumes"
  az        = "${var.AWS_REGIONS}b"
  size      = "${split(",", var.size)}"
  encrypted = "${var.encrypted}"

  # general tags
  name        = "${split(",", var.name)}"
  template    = "${var.template}"
  environment = "${terraform.workspace}"
  created-on  = "${var.creation_date}"
  application = "${var.application}"
  purpose     = "${var.purpose}"
}

resource "aws_volume_attachment" "ebs_att" {
  count       = "${length(var.device-name)}"
  device_name = "/dev/${element(var.device-name, count.index)}"                                     # need to be a string
  volume_id   = "${element(module.volume.volume-id, count.index)}"                                  # volume-id, need to a single value
  instance_id = "${element(element(element(data.terraform_remote_state.ec2.outputs.id, 0), 0), 0)}" # instance-id
}
