variable "az" {
  type    = "string"
  default = ""
}

variable "size" {
  type    = "list"
  default = []
}

variable "type" {
  type    = "string"
  default = ""
}

variable "encrypted" {
  type    = "string"
  default = ""
}

variable "iops" {
  type    = "string"
  default = ""
}

variable "snapshot-id" {
  type    = "string"
  default = ""
}

variable "kms-id" {
  type    = "string"
  default = ""
}

variable "tags" {
  type    = "map"
  default = {}
}