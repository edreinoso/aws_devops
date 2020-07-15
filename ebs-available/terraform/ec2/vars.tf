variable "AWS_REGIONS" {
  default = "us-east-1"
}

variable "template" {
  type    = "string"
  default = "ebs-volume-available"
}

variable "creation_date" {
    type = "string"
    default = "Jul_10_2018"
}

variable "application" {
    type = "string"
    default = "ebs-volume-available"
}

variable "purpose" {
    type = "string"
    default = "aws_devops"
}

# EC2
#Web | NAT
variable "ami" {
  type    = "string"
  default = "ami-08f3d892de259504d"
}

variable "instance-type" {
  type    = "string"
  default = "t2.micro"
}

variable "public-ip-association-true" {
  type    = "string"
  default = "true"
}

variable "source-check" {
  type = "map"
  default = {
      enable = "true"
      disable = ""
  }
}

variable "public-ip-association" {
    type = "map"
    default = {
        yes = "true"
        no = ""
    }
}

variable "key-name" {
    type = "map"
    default = {
        public = "base-template"
        private = "internal-base-template"
    }
}

variable "ec2-name" {
  type    = "string"
  default = "ebs-volume-available"
}

variable "instance-role" {
    type = "string"
    default = "EC2_Role"
}