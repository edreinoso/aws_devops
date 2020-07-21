# VPC Ouputs
output "vpc-id" {
  value = ["${module.new-vpc.vpc-id}"]
}

# Route Table Ouputs
output "pub-route-table" {
  value = ["${module.publicRT.rt-id}"]
}

# this would be the necessary for the natting
output "pri-route-table" {
  value = ["${module.privateRT.rt-id}"]
}

# Subnet Ouputs
output "pub-subnet-1-id" {
  value = ["${module.pub_subnet_1.subnet-id}"]
}

output "pub-subnet-2-id" {
  value = ["${module.pub_subnet_2.subnet-id}"]
}

output "pri-subnet-1-id" {
  value = ["${module.pri_subnet_1.subnet-id}"]
}

output "pri-subnet-2-id" {
  value = ["${module.pri_subnet_2.subnet-id}"]
}