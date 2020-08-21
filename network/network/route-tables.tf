# PUBLIC ROUTE TABLE
module "publicRT" {
  source = "/Users/elchoco/aws/terraform_infrastructure_as_code/modules/network/route-tables/rt"
  vpc-id = "${module.new-vpc.vpc-id}"
  tags = {
    "Environment"   = "${terraform.workspace}"
    "Template"      = "${var.template}"
    "Application"   = "${var.application}"
    "Purpose"       = "${var.purpose}"
    "Creation_Date" = "${var.created-on}"
    "Name"          = "${var.publicRouteTable}"
  }
  # rtName      = "${var.publicRouteTable}"
  # template    = "${var.template}"
  # environment = "${terraform.workspace}"
  # created-on  = "${formatdate("MMMM-DD-YYYY-hh-mm-ss", timestamp())}"
}

# module "rtToPubSubnet1" {
#   source       = "/Users/elchoco/aws/terraform_infrastructure_as_code/modules/network/route-tables/rtAssociation"
#   subnet-ids   = "${module.pub_subnet_1.subnet-id}"
#   rt-id        = "${module.publicRT.rt-id}"
#   subnet-cidrs = "${split(",", lookup(var.az1PublicSubnetCidr, terraform.workspace))}"
# }

# module "rtToPubSubnet2" {
#   source       = "/Users/elchoco/aws/terraform_infrastructure_as_code/modules/network/route-tables/rtAssociation"
#   subnet-ids   = "${module.pub_subnet_2.subnet-id}"
#   rt-id        = "${module.publicRT.rt-id}"
#   subnet-cidrs = "${split(",", lookup(var.az2PublicSubnetCidr, terraform.workspace))}"
# }

module "publicRoutes" {
  source       = "/Users/elchoco/aws/terraform_infrastructure_as_code/modules/network/route-tables/route"
  routeTableId = "${module.publicRT.rt-id}"
  destination  = "${var.destinationRoute}"
  igw          = "${module.igw-vpc.igw-id}"
}

# PRIVATE ROUTE TABLE
module "privateRT" {
  source = "/Users/elchoco/aws/terraform_infrastructure_as_code/modules/network/route-tables/rt"
  vpc-id = "${module.new-vpc.vpc-id}"
  tags = {
    "Environment"   = "${terraform.workspace}"
    "Template"      = "${var.template}"
    "Application"   = "${var.application}"
    "Purpose"       = "${var.purpose}"
    "Creation_Date" = "${var.created-on}"
    "Name"          = "${var.privateRouteTable}"
  }
  # rtName      = "${var.privateRouteTable}"
  # template    = "${var.template}"
  # environment   = "${terraform.workspace}"
  # created-on  = "${formatdate("MMMM-DD-YYYY-hh-mm-ss", timestamp())}"
}

# module "rtToPriSubnet1" {
#   source       = "/Users/elchoco/aws/terraform_infrastructure_as_code/modules/network/route-tables/rtAssociation"
#   subnet-ids   = "${module.pri_subnet_1.subnet-id}"
#   rt-id        = "${module.privateRT.rt-id}"
#   subnet-cidrs = "${split(",", lookup(var.az1PrivateSubnetCidr, terraform.workspace))}"
# }

module "rtToPriSubnet2" {
  source       = "/Users/elchoco/aws/terraform_infrastructure_as_code/modules/network/route-tables/rtAssociation"
  subnet-ids   = "${module.pri_subnet_2.subnet-id}"
  rt-id        = "${module.privateRT.rt-id}"
  subnet-cidrs = "${split(",", lookup(var.az2PrivateSubnetCidr, terraform.workspace))}"
}
