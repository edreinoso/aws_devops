variable "elb-name" {
  type    = string
  default = ""

  # type    = list
  # default = []
}

variable "tags" {
  type    = map
  default = {}
}

variable "elb-type" {
  type    = string
  default = ""
}

variable "internal-elb" {
  type    = string
  default = ""
}

variable "subnet-ids" {
  type    = list
  default = []
}

variable "security-group" {
  type    = list
  default = []
}

variable "vpc-id" {
  type    = string
  default = ""
}

variable "bucket-name" {
  type    = string
  default = ""
}