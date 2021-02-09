# dynamodb table to record when AMIs were taken
# and for what instance they are coming from
module "dynamodb-table" {
  source         = "github.com/edreinoso/terraform_infrastructure_as_code/modules/storage/dynamodb/"
  name           = var.table-name
  hash-key       = var.primary-key
  billingMode    = var.billing
  read           = var.read-write-capacity
  write          = var.read-write-capacity
  attribute-name = var.primary-key
  attribute-type = var.attribute-type
  streams        = var.streams
  stream-view    = var.stream-view
  ttl-enabled    = var.ttl-enabled
  ttl-attribute  = var.ttl-attribute
  tags = {
    Name          = var.table-name
    Template      = "devops"
    Environment   = terraform.workspace
    Application   = "auto ami automation"
    Purpose       = "ddb table to record data about instances"
    Creation_Date = "Dec 19th"
  }
}

# event source mapping to connect the cleaner function
# to the dynamodb stream from the table above
resource "aws_lambda_event_source_mapping" "cleaner_function" {
  event_source_arn  = module.dynamodb-table.ddb-stream-arn
  function_name     = module.cleaner_function.arn
  starting_position = "LATEST"
}