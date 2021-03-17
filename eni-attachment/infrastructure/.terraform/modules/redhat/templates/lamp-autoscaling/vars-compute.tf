### AUTOSCALING, ELB AND NAT INSTANCE ###


### AUTOSCALING ###

  variable "launch-configuration-name" {
    type    = string
    default = "lc_example"
  }

  variable "autoscaling-name" {
    type    = string
    default = "asg web server"
  }

  # this ami is going to be the one of the web server
  # base Amazon Linux AMI is given below
  variable "ami" {
    type    = string
    default = "ami-08f3d892de259504d"
  }

  variable "instance-type" {
    type    = string
    default = "t2.micro"
  }

  variable "health-check" {
    type    = string
    default = "EC2"
  }

  # variable "role" {
  #   type    = string
  #   default = ""
  # }

  variable "enabled_metrics" {
    type = list
    default = [
      "GroupMinSize",
      "GroupMaxSize",
      "GroupDesiredCapacity",
      "GroupTotalInstances",
    ]
  }

### ELB ###

  variable "elb-name" {
    type    = string
    default = "sample-elb"
  }

  variable "elb-type" {
    type    = string
    default = "application"
  }

  variable "internal-elb" {
    type    = string
    default = "false"
  }

  variable "elb-tg-name" {
    type = string
    default = "sample-target-group"
  }

  variable "tg-port" {
    type    = string
    default = "80"
  }

  variable "tg-protocol" {
    type    = string
    default = "HTTP"
  }

  variable "tg-target-type" {
    type    = string
    default = "instance"
  }

  variable "tg-deregister" {
    type = string

    # monitor for change
    default = "400"
  }

# S3
  variable "bucket-name" {
    type    = string
    default = "load-balancer-logs-elb-ed"
  }

  variable "acl" {
    type    = string
    default = "private"
  }

  variable "destroy" {
    type    = string
    default = "true"
  }

  variable "account-id" {
    type    = string
    default = "130193131803" # your account ID
  }


### EC2 ###

  variable "public-ip-association-true" {
    type    = string
    default = "true"
  }

  variable "public-ip-association-false" {
    type    = string
    default = ""
  }

  variable "sourceCheck-enable" {
    type = string
    default = "true"
  }

  variable "sourceCheck-disable" {
    type = string
    default = ""
  }

  variable "key-name-pub" {
    type    = string
    default = "base-template"
  }

  variable "key-name-pri" {
    type    = string
    default = "internal-base-template"
  }