variable "name" {
  type    = "string"
  default = ""
}

variable "hash-key" {
  type    = "string"
  default = ""
}

variable "write" {
  type    = "string"
  default = ""
}

variable "read" {
  type    = "string"
  default = ""
}

variable "billingMode" {
  type    = "string"
  default = ""
}

variable "streams" {
  type    = "string"
  default = ""
}

variable "stream-view" {
  type    = "string"
  default = ""
}

variable "ttl-enabled" {
  type    = "string"
  default = ""
}

variable "ttl-attribute" {
  type    = "string"
  default = ""
}

variable "tags" {
  type    = "map"
  default = {}
}

## Attributes
variable "attribute-name" {
  type    = "string"
  default = ""
}

variable "attribute-type" {
  type    = "string"
  default = ""
}

# variable "range_key" {
#   type        = string
#   default     = ""
#   description = "DynamoDB table Range Key"
# }

# variable "range_key_type" {
#   type        = string
#   default     = "S"
#   description = "Range Key type, which must be a scalar type: `S`, `N`, or `B` for (S)tring, (N)umber or (B)inary data"
# }

# variable "attributes" {
#   type        = list(string)
#   default     = []
#   description = "Additional attributes (e.g. `1`)"
# }

# variable "dynamodb_attributes" {
#   type = list(object({
#     name = string
#     type = string
#   }))
#   default     = []
#   description = "Additional DynamoDB attributes in the form of a list of mapped values"
# }
