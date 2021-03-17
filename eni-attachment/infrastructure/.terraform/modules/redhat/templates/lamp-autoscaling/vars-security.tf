
### SECURITY GROUPS ###
  variable "protocol" {
    description = "specify which protocol a certain security group is from"
    type        = map
    default     = {
      "nat" = "ssh"
      "elb" = "http"
      "web" = "ssh-http"
      "app" = "ssh-http"
      "db"  = "mysql"
    }
  }
  
  variable "sg-name-pub" {
    type    = string
    default = "pub"
  }

  variable "sg-name-pri" {
    type    = string
    default = "pri"
  }

  variable "sg-name-elb" {
    type    = string
    default = "elb"
  }

  variable "ips" {
    type    = string
    default = "80.112.143.163/32" # your IP addresses that you want to provide access to your infrastructure
  }