resource "aws_network_acl" "nacl" {
  vpc_id = "${var.vpc-id}"
  subnet_ids = "${var.subnet-ids}"
  tags = {
    Name          = "${var.name}"
    Environment   = "${var.environment}"
    Template      = "${var.template}"
    Application   = "${var.application}"
    Purpose       = "${var.purpose}"
    Creation_Date = "${var.created-on}"
  }
}