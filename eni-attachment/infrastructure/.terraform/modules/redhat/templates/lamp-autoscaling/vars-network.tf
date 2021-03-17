#VPC Components
  variable "vpc-name" {
    type    = string
    default = "terraform-deployment-vpc"
  }

  variable "vpc-cidr" {
    type = map

    default = {
      dev = "172.168.0.0/24"
    }
  }

  variable "vpc-dns-hostname" {
    type    = string
    default = true
  }

  variable "vpc-dns-support" {
    type    = string
    default = true
  }

#Flow logs
  variable "flow-logs-name" {
    type    = string
    default = "template-1-autoscaling-flow-logs"
  }

  variable "log-destination" {
    type    = string
    default = "/aws/lamp-autoscaling" #for now this would be example
  }

  variable "traffic-type" {
    type    = string
    default = "ALL"
  }

  variable "role-policy-name" {
    type    = string
    default = "flow-logs-policy"
  }

  variable "role-name" {
    type    = string
    default = "flow-logs-roles"
  }

  variable "max-aggregation-interval" {
    type    = string
    default = "600"
  }

#Internet gateway
  variable "igw-name" {
    type    = string
    default = "sample-igw"
  }

#Subnet component
  #Public subnets -- these subnets are in different availability zones
  variable "public-type" {
    type    = string
    default = "public"
  }

  variable "az1PublicSubnetCidr" {
    type = map

    default = {
      dev = "172.168.0.0/27"
    }
  }

  variable "az1PublicSubnetNames" {
    type = map

    default = {
      dev = "public-subnet-01"
    }
  }

  variable "az2PublicSubnetCidr" {
    type = map

    default = {
      dev = "172.168.0.32/27"
    }
  }

  variable "az2PublicSubnetNames" {
    type = map

    default = {
      dev = "public-subnet-02"
    }
  }

  variable "publicSubnet" {
    type    = string
    default = "public"
  }

  #Private subnets
  variable "private-type" {
    type    = string
    default = "private"
  }

  variable "az1PrivateSubnetCidr" {
    type = map

    default = {
      dev = "172.168.0.64/27,172.168.0.96/27,172.168.0.128/27"
    }
  }

  variable "az1PrivateSubnetNames" {
    type = map

    default = {
      dev = "private-web-subnet-01,private-app-subnet-01,private-db-subnet-01"
    }
  }

  variable "az2PrivateSubnetCidr" {
    type = map

    default = {
      dev = "172.168.0.160/27,172.168.0.192/27,172.168.0.224/27"
    }
  }

  variable "az2PrivateSubnetNames" {
    type = map

    default = {
      dev = "private-web-subnet-02,private-app-subnet-02,private-db-subnet-02"
    }
  }

  variable "privateSubnet" {
    type    = string
    default = "private"
  }

  ## General subnet information
  variable "main-subnet" {
    type    = string
    default = "main-subnet"
  }

  variable "ha-subnet" {
    type    = string
    default = "ha-subnet"
  }

# Route Tables
  variable "publicRouteTable" {
    type    = string
    default = "public-route-table"
  }

  variable "privateRouteTable" {
    type    = string
    default = "private-route-table"
  }

  variable "destinationRoute" {
    type    = string
    default = "0.0.0.0/0"
  }