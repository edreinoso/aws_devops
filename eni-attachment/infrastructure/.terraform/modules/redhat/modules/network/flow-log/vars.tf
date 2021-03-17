## TAGS

variable "tags" {
  type    = map
  default = {}
}

# LOGS

variable "log-destination" {
  type    = string
  default = ""
}

variable "vpc-id" {
  type    = string
  default = ""
}

variable "traffic-type" {
  type    = string
  default = ""
}

variable "max-aggregation-interval" {
  type    = string
  default = ""
}

variable "role-policy-name" {
  type    = string
  default = ""
}

variable "role-name" {
  type    = string
  default = ""
}
