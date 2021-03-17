variable "nacls-id" {
  type = "string"
  default = ""
}

variable "protocol" {
  type    = "string"
  default = ""
}

variable "egress" {
  type = "list"
  default = []
}

variable "rule-no" {
  type    = "list"
  default = []
}

variable "action" {
  type    = "list"
  default = []
}

variable "cidr-block" {
  type    = "list"
  default = []
}

variable "from-port" {
  type    = "string"
  default = ""
}

variable "to-port" {
  type    = "string"
  default = ""
}

## EGRESS
# variable "egress-protocol" {
#   type    = "string"
#   default = ""
# }

# variable "egress-rule-no" {
#   type    = "list"
#   default = []
# }

# variable "egress-action" {
#   type    = "string"
#   default = ""
# }

# variable "egress-cidr-block" {
#   type    = "list"
#   default = []
# }

# variable "egress-from-port" {
#   type    = "string"
#   default = ""
# }

# variable "egress-to-port" {
#   type    = "string"
#   default = ""
# }

# ## INGRESS
# variable "ingress-protocol" {
#   type    = "string"
#   default = ""
# }

# variable "ingress-rule-no" {
#   type    = "list"
#   default = []
# }

# variable "ingress-action" {
#   type    = "string"
#   default = ""
# }

# variable "ingress-cidr-block" {
#   type    = "list"
#   default = []
# }

# variable "ingress-from-port" {
#   type    = "string"
#   default = ""
# }

# variable "ingress-to-port" {
#   type    = "string"
#   default = ""
# }
