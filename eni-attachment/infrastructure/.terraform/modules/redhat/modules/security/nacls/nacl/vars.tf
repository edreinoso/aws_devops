variable "vpc-id" {
  type    = "string"
  default = ""
}

variable "subnet-ids" {
  type = "list"
  default = []
}

## TAGS

variable "name" {
  type        = "string"
  default = ""
}

variable "environment" {
  type        = "string"
  default     = ""
}

variable "purpose" {
  type        = "string"
  default     = ""
}

variable "application" {
  type        = "string"
  default     = ""
}

variable "created-on" {
  type        = "string"
  default     = ""
}

variable "template" {
  type        = "string"
  default     = ""
}
