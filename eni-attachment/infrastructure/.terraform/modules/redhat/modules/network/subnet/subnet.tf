resource "aws_subnet" "subnet" {
  count                   = length(var.subnet-cidr)
  vpc_id                  = var.vpc-id
  cidr_block              = element(var.subnet-cidr, count.index)
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = var.type == "private" ? false : true
  # tags                    = var.tags # this has not been implemented just yet
  tags = {
    Availability  = var.subnet-availability
    Type          = var.type
    Name          = element(var.subnet-name, count.index) # cannot implement other tag just yet since the names depend on the count
    Template      = var.template
    Purpose       = var.purpose
    Creation_Date = var.created-on
  }
}
