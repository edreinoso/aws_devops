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
    dev  = "EBS-encryption-snapshot-dev"
    prod = "EBS_Encryption-snapshot"
  }
}

variable "role" {
  type    = "string"
  default = "arn:aws:iam::130193131803:role/LambdaEC2FullAccess"
}

variable "runtime" {
  type    = "string"
  default = "python2.7"
}

variable "handler" {
  type    = "string"
  default = "lambda_function.lambda_handler"
}

variable "timeout" {
  type    = "string"
  default = "120"
}

variable "memory-size" {
  type    = "string"
  default = "128"
}

# TAGS

variable "template" {
  type    = "string"
  default = "aws_automation"
}

variable "purpose" {
  type    = "string"
  default = "encrypting EBS volumes"
}

variable "application" {
  type    = "string"
  default = "ebs-encryption"
}

variable "creation_date" {
  type    = "string"
  default = "July_18_2020"
}