output "dynamodb-id" {
  value = "${aws_dynamodb_table.dynamodb-table.id}"
}

output "ddb-stream-arn" {
  value = "${aws_dynamodb_table.dynamodb-table.stream_arn}"
}
