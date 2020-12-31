variable "AWS_REGIONS" {
  default = "us-east-1"
}

# DDB

variable "table-name" {
  type    = "string"
  default = "AutoAMIRecord"
}

variable "primary-key" {
  type    = "string"
  default = "instanceId"
}

variable "attribute-type" {
  type    = "string"
  default = "S"
}

variable "read-write-capacity" {
  type    = "string"
  default = "5"
}

variable "billing" {
  type    = "string"
  default = "PROVISIONED"
}

variable "streams" {
  type    = "string"
  default = "true"
}

variable "stream-view" {
  type    = "string"
  default = "NEW_AND_OLD_IMAGES"
}

variable "ttl-enabled" {
  type    = "string"
  default = "true"
}

variable "ttl-attribute" {
  type    = "string"
  default = "expiryDate"
}

# Lambda

variable "file-name-taker" {
  type = "string"
  default = "taker.zip"
}
variable "file-name-cleaner" {
  type = "string"
  default = "cleaner.zip"
}

variable "function-name-taker" {
  type    = "string"
  default = "Auto-AMI-taker"
}
variable "function-name-cleaner" {
  type    = "string"
  default = "Auto-AMI-cleaner"
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
  default = "lambda_handler"
}

variable "timeout" {
  type    = "string"
  default = "100"
}

variable "memory-size" {
  type    = "string"
  default = "128"
}

# this is for including the role policies
variable "roleName" {
  type    = "string"
  default = "LambdaEC2FullAccess"
}
