variable "allocated-storage" {
  type    = "string"
  default = ""
}

variable "storage-type" {
  type    = "string"
  default = ""
}

variable "engine" {
  type    = "string"
  default = ""
}

variable "final-snapshot" {
  type    = "string"
  default = ""
}

variable "snapshot-identifier" {
  type    = "string"
  default = ""
}

variable "engine-version" {
  type    = "string"
  default = ""
}

variable "instance-class" {
  type    = "string"
  default = ""
}

variable "instance-name" {
  type    = "string"
  default = ""
}

variable "username" {
  type    = "string"
  default = ""
}

variable "password" {
  type    = "string"
  default = ""
}

variable "parameter-group-name" {
  type    = "string"
  default = ""
}

variable "rds-name" {
  type    = "string"
  default = ""
}

variable "db-subnet-group" {
  type    = "string"
  default = ""
}

variable "publicly-accessible" {
  type    = "string"
  default = ""
}

variable "availability-zone" {
  type    = "string"
  default = ""
}

variable "vpc-security-group-ids" {
  type    = "list"
  default = []
}

variable "db-identifier" {
  type    = "string"
  default = ""
}

variable "db-port" {
  type    = "string"
  default = ""
}

variable "db-name" {
  type    = "string"
  default = ""
}

variable "skip-final" {
  type    = "string"
  default = ""
}

variable "tags" {
  type    = "map"
  default = {}
}

variable "maintenance-windows" {
  type    = "string"
  default = ""
}
