resource "aws_s3_bucket" "s3" {
  bucket        = "${var.bucket-name}"
  acl           = "${var.acl}"
  force_destroy = "${var.destroy}"

  tags = {
    Name = "${var.bucket-name}"
    Template = "${var.template}"
  }
}
