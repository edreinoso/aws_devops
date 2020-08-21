module "pub_subnet_1" {
  source              = "/Users/elchoco/aws/terraform_infrastructure_as_code/modules/network/subnet"
  vpc-id              = "${module.new-vpc.vpc-id}"
  subnet-cidr         = "${split(",", lookup(var.az1PublicSubnetCidr, terraform.workspace))}"
  availability_zone   = "us-east-1a"
  visibility          = "${var.public-type}"
  subnet-name         = "${split(",", lookup(var.az1PublicSubnetNames, terraform.workspace))}"
  template            = "${var.template}"
  subnet-availability = "${var.main-subnet}"
  type                = "${var.public-type}"
  created-on          = "${var.created-on}"
  environment         = "${terraform.workspace}"
  purpose             = "${var.purpose}"
  application         = "${var.application}"
}

# AZ 2
module "pub_subnet_2" {
  source              = "/Users/elchoco/aws/terraform_infrastructure_as_code/modules/network/subnet"
  vpc-id              = "${module.new-vpc.vpc-id}"
  subnet-cidr         = "${split(",", lookup(var.az2PublicSubnetCidr, terraform.workspace))}"
  availability_zone   = "us-east-1b"
  visibility          = "${var.public-type}"
  # subnet-name         = "${split(",", lookup(var.az2PublicSubnetNames, terraform.workspace))}"
  subnet-name         = ["Hello fucking world"]
  template            = "${var.template}"
  subnet-availability = "${var.ha-subnet}"
  type                = "${var.public-type}"
  created-on          = "${var.created-on}"
  environment         = "${terraform.workspace}"
  purpose             = "${var.purpose}"
  application         = "${var.application}"
}

# Private subnets where the potential app instances / db instances
# AZ 1
module "pri_subnet_1" {
  source              = "/Users/elchoco/aws/terraform_infrastructure_as_code/modules/network/subnet"
  vpc-id              = "${module.new-vpc.vpc-id}"
  subnet-cidr         = "${split(",", lookup(var.az1PrivateSubnetCidr, terraform.workspace))}"
  availability_zone   = "us-east-1a"
  visibility          = "${var.private-type}"
  subnet-name         = "${split(",", lookup(var.az1PrivateSubnetNames, terraform.workspace))}"
  template            = "${var.template}"
  subnet-availability = "${var.main-subnet}"
  type                = "${var.private-type}"
  created-on          = "${var.created-on}"
  environment         = "${terraform.workspace}"
  purpose             = "${var.purpose}"
  application         = "${var.application}"
}

# AZ 2
module "pri_subnet_2" {
  source              = "/Users/elchoco/aws/terraform_infrastructure_as_code/modules/network/subnet"
  vpc-id              = "${module.new-vpc.vpc-id}"
  subnet-cidr         = "${split(",", lookup(var.az2PrivateSubnetCidr, terraform.workspace))}"
  availability_zone   = "us-east-1b"
  visibility          = "${var.private-type}"
  subnet-name         = "${split(",", lookup(var.az2PrivateSubnetNames, terraform.workspace))}"
  template            = "${var.template}"
  subnet-availability = "${var.ha-subnet}"
  type                = "${var.private-type}"
  created-on          = "${var.created-on}"
  environment         = "${terraform.workspace}"
  purpose             = "${var.purpose}"
  application         = "${var.application}"
}
