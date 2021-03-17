output "subnet-group-outputs" {
  value = "${aws_db_subnet_group.rds-subnet-group-private.id}"
}
