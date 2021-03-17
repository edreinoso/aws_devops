resource "aws_route" "route" {
  route_table_id         = var.routeTableId
  destination_cidr_block = var.destination
  gateway_id             = var.igw
  instance_id            = var.instanceId
}
