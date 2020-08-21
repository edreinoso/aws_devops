variable "AWS_REGIONS" {
  default = "us-east-1"
}

variable "devops-sg-name-pub" {
  type    = "string"
  default = "devops"
}

variable "ips" {
  type    = "string"
  default = "100.12.75.72/32"
}

#TAGS
variable "template" {
  type    = "string"
  default = "aws_automation"
}

variable "created-on" {
  type    = "string"
  default = "July_20_2020"
}