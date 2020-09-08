module "dynamodb-table" {
  source         = "/Users/elchoco/aws/terraform_infrastructure_as_code/modules/storage/dynamodb/"
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
