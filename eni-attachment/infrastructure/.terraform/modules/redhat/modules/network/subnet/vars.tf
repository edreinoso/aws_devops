variable "vpc-id" {
  type    = string
  default = ""
}

variable "subnet-cidr" {
  type    = list
  default = []
}

variable "availability_zone" {
  type    = string
  default = ""
}

variable "visibility" {
  type    = string
  default = "private"
}

# variable "tags" {
#   type    = "map"
#   default = {}
# }

#TAGS: to be deprecated
# this change cannot happen just yet
# due to the interrelation between count
# and subnet-name variable
variable "subnet-name" {
  type    = list
  default = []
}

variable "template" {
  type    = string
  default = ""
}

variable "application" {
  type    = string
  default = ""
}

variable "purpose" {
  type    = string
  default = ""
}

variable "environment" {
  type    = string
  default = ""
}

variable "created-on" {
  type    = string
  default = ""
}

variable "subnet-availability" {
  type    = string
  default = ""
}

variable "type" {
  type    = string
  default = ""
}
