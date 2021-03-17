resource "aws_route_table_association" "rtAssociate" {
  count          = length(var.subnet-cidrs)
  subnet_id      = element(var.subnet-ids, count.index)
  route_table_id = var.rt-id
}
