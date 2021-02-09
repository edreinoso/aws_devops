variable "AWS_REGIONS" {
  default = "us-east-1"
}

# EC2
variable "ami" {
  type    = string
  default = "ami-08f3d892de259504d"
}

variable "instance-type" {
  type    = string
  default = "t2.micro"
}

variable "public-ip-association-true" {
  type    = string
  default = "true"
}

variable "source-check" {
  type = map
  default = {
    enable  = "true"
    disable = ""
  }
}

variable "public-ip-association" {
  type = map
  default = {
    yes = "true"
    no  = ""
  }
}

variable "key-name" {
  type = map
  default = {
    public  = "base-template"
    private = "internal-base-template"
  }
}

variable "instance-role" {
  type    = string
  default = "EC2_Role"
}
