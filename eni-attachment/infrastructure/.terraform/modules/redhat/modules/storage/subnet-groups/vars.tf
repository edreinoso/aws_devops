variable "name" {
  type    = "string"
  default = ""
}

variable "subnet-ids" {
  type    = "list"
  default = []
}

variable "environment" {
  type    = "string"
  default = ""
}

variable "template" {
  type    = "string"
  default = ""
}
