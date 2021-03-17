output "volume-id" {
  # star (*) is going to have to be included if
  # there are more than one resources being deployed
  # e.g. count...
  value = "${aws_ebs_volume.volume.*.id}"
}
