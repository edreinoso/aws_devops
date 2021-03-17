resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc-id
  tags   = var.tags
}
