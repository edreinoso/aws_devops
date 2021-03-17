output "rds-id" {
  value = "${aws_db_instance.rds.*.id}"
}

output "rds-hosted-zone" {
  value ="${aws_db_instance.rds.hosted_zone_id}"
}

output "rds-address" {
  value ="${aws_db_instance.rds.address}"
}