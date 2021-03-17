resource "aws_ebs_snapshot" "snapshot" {
  count     = "${var.snap-count}"
  volume_id = "${var.volume-id}"

  # description = "${var.snap-name}-${count.index}"
  description = "${var.snap-name}-${count.index}"

  tags = {
    Name = "${var.snap-name}"
  }
}
