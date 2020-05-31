variable "AWS_REGIONS" {
  default = "us-east-1"
}


variable "custom-ami" {
  type    = "string"
  default = "ebs-extend-may-30"
}

variable "type" {
  type    = "string"
  default = "t2.micro"
}

variable "sourceCheck" {
  type    = "string"
  default = "enabled"
}

variable "public-ip" {
  type    = "string"
  default = "true"
}

variable "keys" {
  type    = "string"
  default = "base-template"
}

variable "instance-role" {
  type    = "string"
  default = "EC2_Role"
}

variable "volume-size" {
  type    = "string"
  default = "10,15,30"
}

# TAGS
variable "ec2-name" {
  type    = "string"
  default = "ebs-extend"
}

variable "template" {
  type    = "string"
  default = "sandbox"
}
variable "application" {
  type = "string"
  default = "ebs-extend"
}
variable "purpose" {
  type = "string"
  default = "devops"
}
variable "created-on" {
  type = "string"
  default = "May 30th 2020"
}