variable "AWS_REGIONS" {
  default = "us-east-1"
}

variable "size" {
  type    = "string"
  default = "25,20,10"
}

variable "name" {
  type    = "string"
  default = "ebs-volume-available-test-1,ebs-volume-available-test-2,ebs-volume-available-test-3"
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

variable "device-name" {
  type    = "list"
  default = ["sdl","sdk","sdm"]
}

variable "encrypted" {
  type    = "string"
  default = "false"
}