variable "AWS_REGIONS" {
  default = "us-east-1"
}

variable "template" {
  type    = "string"
  default = "aws_automation"
}

variable "creation_date" {
    type = "string"
    default = "Jul_10_2018"
}

variable "application" {
    type = "string"
    default = "ebs-encryption"
}

variable "purpose" {
    type = "string"
    default = "encrypting EBS volumes"
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
  default = "ebs-encryption"
}

variable "instance-role" {
    type = "string"
    default = "EC2_Role"
}


variable "roleName" {
  type    = "string"
  default = "LambdaEC2FullAccess"
}

# EBS

variable "size" {
  type    = "string"
  default = "10,20"
}

variable "name" {
  type    = "string"
  default = "independent_ebs_1"
}

variable "device-name" {
  type    = "list"
  default = ["sdl"]
}

variable "encrypted" {
  type    = "string"
  default = "false"
}