resource "aws_instance" "ec2" {
  ami                         = var.ami
  instance_type               = var.instance-type
  subnet_id                   = var.subnet-ids
  key_name                    = var.key-name
  vpc_security_group_ids      = var.security-group-ids
  user_data                   = var.user-data
  iam_instance_profile        = var.instance-role
  associate_public_ip_address = var.public-ip == "" ? false : true
  source_dest_check           = var.sourceCheck == "" ? false : true


  tags = var.tags

  volume_tags = var.tags

  dynamic "ebs_block_device" {
    for_each = var.ebs_block_device
    content {
      delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", null)
      device_name           = ebs_block_device.value.device_name
      volume_size           = lookup(ebs_block_device.value, "volume_size", null)
      volume_type           = lookup(ebs_block_device.value, "volume_type", null)
      iops                  = lookup(ebs_block_device.value, "iops", null)
      snapshot_id           = lookup(ebs_block_device.value, "snapshot_id", null)
      encrypted             = lookup(ebs_block_device.value, "encrypted", null)
      kms_key_id            = lookup(ebs_block_device.value, "kms_key_id", null)
    }
  }
}
