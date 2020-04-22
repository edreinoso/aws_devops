variable "AWS_REGIONS" {
  default = "us-east-1"
}

variable "table-name" {
  type    = "string"
  default = "IAMUserListMonitoring"
}

variable "primary-key" {
  type    = "string"
  default = "username"
}

variable "attribute-type" {
  type    = "string"
  default = "S"
}

variable "read-write-capacity" {
  type    = "string"
  default = "5"
}

variable "billing" {
  type    = "string"
  default = "PROVISIONED"
}

variable "streams" {
  type    = "string"
  default = "true"
}

variable "stream-view" {
  type    = "string"
  default = "NEW_AND_OLD_IMAGES"
}
