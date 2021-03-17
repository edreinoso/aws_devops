variable "vpc-cidr" {
  type    = string
  default = ""
}

variable "enable-dns-hostname" {
  type    = string
  default = ""
}

variable "enable-dns-support" {
  type    = string
  default = ""
}

variable "tags" {
  type    = map
  default = {}
}