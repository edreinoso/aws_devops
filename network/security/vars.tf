variable "AWS_REGIONS" {
  default = "us-east-1"
}

variable "devops-sg-name-pub" {
  type    = string
  default = "devops"
}

variable "ips" {
  type    = string
  default = "145.108.83.236/32,80.112.143.163/32"
}

#TAGS
variable "template" {
  type    = string
  default = "aws_automation"
}

variable "created-on" {
  type    = string
  default = "July_20_2020"
}