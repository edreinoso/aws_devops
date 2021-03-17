variable "file-name" {
  type    = "string"
  default = ""
}

variable "function-name" {
  type    = "string"
  default = ""
}

variable "role" {
  type    = "string"
  default = ""
}

variable "handler" {
  type    = "string"
  default = ""
}

variable "runtime" {
  type    = "string"
  default = ""
}

variable "layers" {
  description = "List of Lambda Layer Version ARNs (maximum of 5) to attach to your Lambda Function."
  type        = list(string)
  default     = null
}

variable "timeout" {
  type    = "string"
  default = ""
}

variable "memory-size" {
  type    = "string"
  default = ""
}

variable "tags" {
  type    = "map"
  default = {}
}
