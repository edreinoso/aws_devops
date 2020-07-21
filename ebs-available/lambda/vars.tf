variable "AWS_REGIONS" {
  default = "us-east-1"
}

variable "file-name" {
  type = "map"
  default = {
    dev  = "dev_lambda_function.zip"
    prod = "prod_lambda_function.zip"
  }
}

variable "function-name" {
  type = "map"
  default = {
    dev  = "EBS-available-dev"
    prod = "EBS_Available"
  }
}

variable "role" {
  type    = "string"
  default = "arn:aws:iam::130193131803:role/LambdaEC2FullAccess"
}

variable "roleName" {
  type    = "string"
  default = "LambdaEC2FullAccess"
}

variable "runtime" {
  type    = "string"
  default = "python2.7"
}

variable "handler" {
  type    = "string"
  default = "lambda_function.lambda_handler"
}

variable "template" {
  type    = "string"
  default = "aws_automation"
}

variable "purpose" {
  type    = "string"
  default = "ebs-available"
}

variable "application" {
  type    = "string"
  default = "ebs-available"
}

variable "creation_date" {
  type    = "string"
  default = "July_18_2020"
}

variable "timeout" {
  type    = "string"
  default = "90"
}

variable "memory-size" {
  type    = "string"
  default = "128"
}
