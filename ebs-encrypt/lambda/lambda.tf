module "function" {
  source        = "/Users/elchoco/aws/terraform_infrastructure_as_code/modules/compute/lambda"
  file-name     = "${lookup(var.file-name, terraform.workspace)}"
  function-name = "${lookup(var.function-name, terraform.workspace)}"
  role          = "${var.role}"
  handler       = "${var.handler}"
  runtime       = "${var.runtime}"
  timeout       = "${var.timeout}"
  memory-size   = "${var.memory-size}"
  tags = {
    "Environment"   = "${terraform.workspace}"
    "Template"      = "${var.template}"
    "Application"   = "${var.application}"
    "Purpose"       = "${var.purpose}"
    "Creation_Date" = "${formatdate("MMMM-DD-YYYY-hh-mm-ss", timestamp())}"
    "Name"          = "${lookup(var.function-name, terraform.workspace)}"
  }
}
