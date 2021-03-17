resource "aws_ebs_volume" "volume" {
  count             = "${length(var.size)}"
  availability_zone = "${var.az}"
  type              = "${var.type}"
  size              = "${element(var.size, count.index)}"
  encrypted         = "${var.encrypted}"
  snapshot_id       = "${var.snapshot-id}"
  kms_key_id        = "${var.kms-id}"
  #   iops              = "${var.iops}"

  tags = var.tags
}
