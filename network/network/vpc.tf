module "new-vpc" {
  source              = "/Users/elchoco/aws/terraform_infrastructure_as_code/modules/network/vpc"
  vpc-cidr            = "${lookup(var.vpc-cidr, terraform.workspace)}"
  enable-dns-support  = "${var.vpc-dns-support}"
  enable-dns-hostname = "${var.vpc-dns-hostname}"
  #TAGS
  vpc-name   = "${lookup(var.vpc-name, terraform.workspace)}"
  template   = "${var.template}"
  created-on = "${var.created-on}"
}

module "igw-vpc" {
  source = "/Users/elchoco/aws/terraform_infrastructure_as_code/modules/network/igw"
  vpc-id = "${module.new-vpc.vpc-id}"
  #TAGS
  igwName    = "${var.igw-name}"
  template   = "${var.template}"
  created-on = "${var.created-on}"
}
