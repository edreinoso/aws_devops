resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc-cidr
  enable_dns_support   = var.enable-dns-support
  enable_dns_hostnames = var.enable-dns-hostname
  tags                 = var.tags
}
