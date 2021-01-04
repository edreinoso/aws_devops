module "volume-no-ebs" {
  source    = "github.com/edreinoso/terraform_infrastructure_as_code/modules/compute/volumes"
  az        = "${var.AWS_REGIONS}b"
  size      = "${split(",", var.size)}"
  encrypted = "${var.encrypted}"

  tags = {
    Name          = "${var.name}"
    Template      = "aws_devops"
    Environment   = "${terraform.workspace}"
    Application   = "ebs_encrypt"
    Purpose       = "Testing ebs encryption"
    Creation_Date = "Jan_1_2021"
  }
}

# resource "aws_volume_attachment" "ebs_att-no-ebs" {
#   count       = "${length(var.device-name)}"
#   device_name = "/dev/${element(var.device-name, count.index)}"           # need to be a string
#   volume_id   = "${element(module.volume-no-ebs.volume-id, count.index)}" # volume-id, need to a single value
#   instance_id = "${module.ec2-no-ebs.ec2-id}"                 # instance-id
# }
