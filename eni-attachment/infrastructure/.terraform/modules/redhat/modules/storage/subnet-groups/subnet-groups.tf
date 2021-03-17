resource "aws_db_subnet_group" "rds-subnet-group-private" {
  name       = "${var.name}"
  subnet_ids = "${var.subnet-ids}"

  tags = {
    Name        = "${var.name}"
    Environment = "${var.environment}"
    Template    = "${var.template}"
  }
}
