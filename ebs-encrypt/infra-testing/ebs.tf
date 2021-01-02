# module "volume-no-ebs" {
#   source    = "/Users/elchoco/aws/terraform_infrastructure_as_code/modules/compute/volumes"
#   az        = "${var.AWS_REGIONS}b"
#   size      = "${split(",", var.size)}"
#   encrypted = "${var.encrypted}"

#   # general tags
#   name        = "${split(",", var.name)}"
#   template    = "${var.template}"
#   environment = "${terraform.workspace}"
#   created-on  = "${formatdate("MMMM-DD-YYYY-hh-mm-ss", timestamp())}"
#   application = "${var.application}"
#   purpose     = "${var.purpose}"
# }

# resource "aws_volume_attachment" "ebs_att-no-ebs" {
#   count       = "${length(var.device-name)}"
#   device_name = "/dev/${element(var.device-name, count.index)}"           # need to be a string
#   volume_id   = "${element(module.volume-no-ebs.volume-id, count.index)}" # volume-id, need to a single value
#   instance_id = "${module.ec2-no-ebs.ec2-id}"                 # instance-id
# }
