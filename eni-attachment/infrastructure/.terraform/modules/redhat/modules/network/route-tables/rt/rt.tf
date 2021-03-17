resource "aws_route_table" "rt" {
  vpc_id = var.vpc-id
  tags   = var.tags
}
