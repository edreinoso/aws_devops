# Public subnet where the potential web server instances/bastion hosts will be created
module "pub_subnet_1" {
  source            = "/Users/elchoco/aws/terraform_infrastructure_as_code/modules/network/subnet"
  vpc-id            = "${module.new-vpc.vpc-id}"
  subnet-cidr       = "${split(",", lookup(var.az1PublicSubnetCidr, terraform.workspace))}"
  availability_zone = "us-east-1a"
  #TAGS
  subnet-name         = "${split(",", lookup(var.az1PublicSubnetNames, terraform.workspace))}"
  template            = "${var.template}"
  subnet-availability = "${var.main-subnet}"
  type                = "${var.public-type}"
  created-on          = "${var.created-on}"
  environment         = "${terraform.workspace}"
}

module "pub_subnet_2" {
  source            = "/Users/elchoco/aws/terraform_infrastructure_as_code/modules/network/subnet"
  vpc-id            = "${module.new-vpc.vpc-id}"
  subnet-cidr       = "${split(",", lookup(var.az2PublicSubnetCidr, terraform.workspace))}"
  availability_zone = "us-east-1b"
  #TAGS
  subnet-name         = "${split(",", lookup(var.az2PublicSubnetNames, terraform.workspace))}"
  template            = "${var.template}"
  subnet-availability = "${var.ha-subnet}"
  type                = "${var.public-type}"
  created-on          = "${var.created-on}"
  environment         = "${terraform.workspace}"
}

# Private subnets where the potential app instances / db instances
module "pri_subnet_1" {
  source            = "/Users/elchoco/aws/terraform_infrastructure_as_code/modules/network/subnet"
  vpc-id            = "${module.new-vpc.vpc-id}"
  subnet-cidr       = "${split(",", lookup(var.az1PrivateSubnetCidr, terraform.workspace))}"
  availability_zone = "us-east-1a"
  #TAGS
  subnet-availability = "${var.main-subnet}"
  subnet-name         = "${split(",", lookup(var.az1PrivateSubnetNames, terraform.workspace))}"
  template            = "${var.template}"
  type                = "${var.private-type}"
  created-on          = "${var.created-on}"
  environment         = "${terraform.workspace}"
}

module "pri_subnet_2" {
  source            = "/Users/elchoco/aws/terraform_infrastructure_as_code/modules/network/subnet"
  vpc-id            = "${module.new-vpc.vpc-id}"
  subnet-cidr       = "${split(",", lookup(var.az2PrivateSubnetCidr, terraform.workspace))}"
  availability_zone = "us-east-1b"
  #TAGS
  subnet-name         = "${split(",", lookup(var.az2PrivateSubnetNames, terraform.workspace))}"
  template            = "${var.template}"
  subnet-availability = "${var.ha-subnet}"
  type                = "${var.private-type}"
  created-on          = "${var.created-on}"
  environment         = "${terraform.workspace}"
}
