variable "listener-port" {
  type    = string
  default = ""
}

variable "listener-protocol" {
  type    = string
  default = ""
}

variable "elb-arn" {
  type    = string
  default = ""
}

variable "target-group-arn" {
  type    = string
  default = ""
}

variable "certificate-arn" {
  type    = string
  default = ""
}

variable "ssl-policy" {
  type = string
  default = ""
}