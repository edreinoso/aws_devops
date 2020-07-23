# confused about the structure of this outputs.
# test and see where it takes you.

output "id" {
  value = [module.ec2-no-ebs.*.ec2-id]
}

output "public-dns" {
    value = "${module.ec2-no-ebs.public-dns}"
}

# output "id" {
#   value = [module.ec2.*.ec2-id]
# }

# output "public-dns" {
#     value = "${module.ec2.public-dns}"
# }