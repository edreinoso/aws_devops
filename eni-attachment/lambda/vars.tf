variable "AWS_REGIONS" {
  default = "us-east-1"
}

# Lambda

variable "file-name-eni" {
  type = string
  default = "eni.zip"
}

variable "description" {
  type = string
  default = "Attach ENIs to RHEL and CentOS (6 and 7) EC2 instances"
}

variable "function-name-eni" {
  type    = string
  default = "eni-attachment"
}

variable "role" {
  type    = string
  default = "arn:aws:iam::130193131803:role/LambdaEC2FullAccess"
}

variable "runtime" {
  type    = string
  default = "python3.8"
}

variable "handler" {
  type    = string
  default = "lambda_handler"
}

variable "timeout" {
  type    = string
  default = "60"
}

variable "memory-size" {
  type    = string
  default = "128"
}

# this is for including the role policies
variable "roleName" {
  type    = string
  default = "LambdaEC2FullAccess"
}
