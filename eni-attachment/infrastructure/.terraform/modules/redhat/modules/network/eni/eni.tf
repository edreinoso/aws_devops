resource "aws_network_interface" "eni" {
  #if ${data.aws_network_interface.get-aws-nic}
  count           = length(var.subnet-ids)
  subnet_id       = element(var.subnet-ids, count.index)
  security_groups = [element(var.security-groups, count.index)]
  # security_groups = ["${split(",", var.security-groups)}"]

  # private_ips = ["${element(var.private-ips, count.index)}"]

  # Attachment has to be defined in order to determine which instance it's going
  # to be mapped to
  attachment {
    instance     = var.instance-id
    device_index = 1
  }
  tags = {
    Name = element(var.ec2-name, count.index)
  }
}
