resource "aws_dynamodb_table" "dynamodb-table" {
  name             = "${var.name}"        # required
  hash_key         = "${var.hash-key}"    # required
  billing_mode     = "${var.billingMode}" # PAY_PER_REQUEST | optional
  read_capacity    = "${var.read}"        # optional
  write_capacity   = "${var.write}"       # optional
  stream_enabled   = "${var.streams}"
  stream_view_type = "${var.stream-view}"
  # range_key      = "GameTitle"   # optional

  attribute {
    name = "${var.attribute-name}" #required
    type = "${var.attribute-type}" # S, N, or B for (S)tring, (N)umber or (B)inary data
  }

  ttl {
    enabled        = "${var.ttl-enabled}"
    attribute_name = "${var.ttl-attribute}"
  }

  # dynamic "attribute" {
  #   for_each = local.attributes_final
  #   content {
  #     name = attribute.value.name
  #     type = attribute.value.type
  #   }
  # }

  tags = var.tags

  # ttl { #optional
  #   attribute_name = "TimeToExist"
  #   enabled        = false
  # }

  # global_secondary_index { #optional
  #   name               = "GameTitleIndex"
  #   hash_key           = "GameTitle"
  #   range_key          = "TopScore"
  #   write_capacity     = 10
  #   read_capacity      = 10
  #   projection_type    = "INCLUDE"
  #   non_key_attributes = ["UserId"]
  # }
}

# locals {
#   attributes = concat(
#     [
#       {
#         name = var.range_key
#         type = var.range_key_type
#       },
#       {
#         name = var.hash_key
#         type = var.hash_key_type
#       }
#     ],
#     var.dynamodb_attributes
#   )

#   # Remove the first map from the list if no `range_key` is provided
#   from_index = length(var.range_key) > 0 ? 0 : 1

#   attributes_final = slice(local.attributes, local.from_index, length(local.attributes))
# }
