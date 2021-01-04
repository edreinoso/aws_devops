module "function_1" {
  source        = "github.com/edreinoso/terraform_infrastructure_as_code/modules/compute/lambda"
  file-name     = "${lookup(var.file-name, "taker")}"
  function-name = "${lookup(var.function-name, "taker")}"
  handler       = "${lookup(var.handler, "taker")}"
  timeout       = "${lookup(var.timeout, "taker")}"
  role          = "${aws_iam_role.role.arn}"
  runtime       = "${var.runtime}"
  memory-size   = "${var.memory-size}"
  tags = {
    "Environment"   = "none"
    "Template"      = "aws-devops"
    "Application"   = "ebs-encryption"
    "Purpose"       = "Functions to take snapshots and encrypt EBS volume"
    "Creation_Date" = "Jul_18th_2020"
    "Modified_Date" = "Jan_3rd_2021"
    "Name"          = "${lookup(var.function-name, "taker")}"
  }
}

module "function_2" {
  source        = "github.com/edreinoso/terraform_infrastructure_as_code/modules/compute/lambda"
  file-name     = "${lookup(var.file-name, "creator")}"
  function-name = "${lookup(var.function-name, "creator")}"
  handler       = "${lookup(var.handler, "creator")}"
  timeout       = "${lookup(var.timeout, "creator")}"
  role          = "${aws_iam_role.role.arn}"
  runtime       = "${var.runtime}"
  memory-size   = "${var.memory-size}"
  tags = {
    "Environment"   = "none"
    "Template"      = "aws-devops"
    "Application"   = "ebs-encryption"
    "Purpose"       = "Functions to take snapshots and encrypt EBS volume"
    "Creation_Date" = "Jul_18th_2020"
    "Modified_Date" = "Jan_3rd_2021"
    "Name"          = "${lookup(var.function-name, "creator")}"
  }
}

module "function_3" {
  source        = "github.com/edreinoso/terraform_infrastructure_as_code/modules/compute/lambda"
  file-name     = "${lookup(var.file-name, "remover")}"
  function-name = "${lookup(var.function-name, "remover")}"
  handler       = "${lookup(var.handler, "remover")}"
  timeout       = "${lookup(var.timeout, "remover")}"
  role          = "${aws_iam_role.role.arn}"
  runtime       = "${var.runtime}"
  memory-size   = "${var.memory-size}"
  tags = {
    "Environment"   = "none"
    "Template"      = "aws-devops"
    "Application"   = "ebs-encryption"
    "Purpose"       = "Functions to take snapshots and encrypt EBS volume"
    "Creation_Date" = "Jul_18th_2020"
    "Modified_Date" = "Jan_3rd_2021"
    "Name"          = "${lookup(var.function-name, "remover")}"
  }
}