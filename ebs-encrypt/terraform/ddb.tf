module "dynamodb-table" {
  source         = "github.com/edreinoso/terraform_infrastructure_as_code/modules/storage/dynamodb/"
  name           = "${var.table-name}"
  hash-key       = "${var.primary-key}"
  billingMode    = "${var.billing}"
  read           = "${var.read-write-capacity}"
  write          = "${var.read-write-capacity}"
  attribute-name = "${var.primary-key}"
  attribute-type = "${var.attribute-type}"
  streams        = "${var.streams}"
  ttl-enabled    = "${var.ttl-enabled}"
  stream-view    = ""
  ttl-attribute  = ""
  tags = {
    Name          = "${var.table-name}"
    Template      = "devops"
    Environment   = "none"
    Application   = "ebs-encryption"
    Purpose       = "ddb table to record data about volumes/snapshots"
    Creation_Date = "Jul_18th_2020"
    Modified_Date = "Jan_3th_2021"
  }
}
