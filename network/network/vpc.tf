module "new-vpc" {
  source              = "/Users/elchoco/aws/terraform_infrastructure_as_code/modules/network/vpc"
  vpc-cidr            = "${lookup(var.vpc-cidr, terraform.workspace)}"
  enable-dns-support  = "${var.vpc-dns-support}"
  enable-dns-hostname = "${var.vpc-dns-hostname}"
  #TAGS
  tags = {
    "Environment"   = "${terraform.workspace}"
    "Template"      = "${var.template}"
    "Application"   = "${var.application}"
    "Purpose"       = "${var.purpose}"
    "Creation_Date" = "${var.created-on}"
    "Name"          = "${var.vpc-name}-${terraform.workspace}"
  }

}

module "igw-vpc" {
  source = "/Users/elchoco/aws/terraform_infrastructure_as_code/modules/network/igw"
  vpc-id = "${module.new-vpc.vpc-id}"
  #TAGS
  tags = {
    "Environment"   = "${terraform.workspace}"
    "Template"      = "${var.template}"
    "Application"   = "${var.application}"
    "Purpose"       = "${var.purpose}"
    "Creation_Date" = "${var.created-on}"
    "Name"          = "${var.igw-name}"
  }
  #TAGS
  # igwName    = "${var.igw-name}"
  # template   = "${var.template}"
  # created-on = "${var.created-on}"
}
