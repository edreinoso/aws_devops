module "dynamodb-table" {
  source         = "/Users/ELCHOCO/AWS/aws-infra-template/modules/dynamodb"
  name           = "${var.table-name}"
  hash-key       = "${var.primary-key}"
  billingMode    = "${var.billing}"
  read           = "${var.read-write-capacity}"
  write          = "${var.read-write-capacity}"
  attribute-name = "${var.primary-key}"
  attribute-type = "${var.attribute-type}"
  streams        = "${var.streams}"
  stream-view    = "${var.stream-view}"
  ttl-enabled    = "${var.ttl-enabled}"
  ttl-attribute  = "${var.ttl-attribute}"
}
