variable "AWS_REGIONS" {
  default = "us-east-1"
}

variable "template" {
  type    = string
  default = "infrastructure-as-code"
}

variable "created-on" {
  type    = string
  default = "August_14_2020"
}

variable "application" {
  type    = string
  default = "template-1-autoscaling"
}

variable "purpose" {
  type    = string
  default = "testing_autoscaling_modes"
}
