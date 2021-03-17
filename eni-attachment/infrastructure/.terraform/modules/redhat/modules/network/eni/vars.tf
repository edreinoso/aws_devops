variable "subnet-ids" {
  type    = list
  default = []
}

# variable "private-ips" {
#   type    = list
#   default = []
# }

variable "ec2-name" {
  type    = list
  default = []
}

variable "instance-id" {
  type    = "string"
  default = ""
}

variable "security-groups" {
  type    = list
  default = []
}
