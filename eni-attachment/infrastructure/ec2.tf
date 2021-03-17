data "terraform_remote_state" "security" {
  backend = "s3"
  config = {
    bucket = "terraform-state-er"
    key    = "env:/dev/aws_devops/security.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "terraform-state-er"
    key    = "env:/dev/aws_devops/network.tfstate"
    region = "us-east-1"
  }
}

module "amazon_linux" {
  source        = "github.com/edreinoso/terraform_infrastructure_as_code/modules/compute/ec2"
  ami           = var.ami["amazon"]
  instance-type = var.instance-type
  subnet-ids = element(
    element(data.terraform_remote_state.vpc.outputs.pub-subnet-1-id, 1),
    1,
  )
  public-ip          = var.public-ip-association["yes"]
  instance-role      = var.instance-role
  sourceCheck        = var.source-check["enable"]
  key-name           = var.key-name["public"]
  security-group-ids = split(",", data.terraform_remote_state.security.outputs.aws-devops-sg-id)
  tags = {
    Name          = "eni_attch_al_az_a"
    Template      = "devops"
    Environment   = terraform.workspace
    Application   = "eni attachment"
    Purpose       = "launching amazon test linux instance to try the eni attachment"
    Creation_Date = "12 March"
  }
}

module "redhat" {
  source        = "github.com/edreinoso/terraform_infrastructure_as_code/modules/compute/ec2"
  ami           = var.ami["redhat"]
  instance-type = var.instance-type
  subnet-ids = element(
    element(data.terraform_remote_state.vpc.outputs.pub-subnet-1-id, 1),
    1,
  )
  public-ip          = var.public-ip-association["yes"]
  instance-role      = var.instance-role
  sourceCheck        = var.source-check["enable"]
  key-name           = var.key-name["public"]
  security-group-ids = split(",", data.terraform_remote_state.security.outputs.aws-devops-sg-id)
  tags = {
    Name          = "eni_attch_rh_az_a"
    Template      = "devops"
    Environment   = terraform.workspace
    Application   = "eni attachment"
    Purpose       = "launching redhat test linux instance to try the eni attachment"
    Creation_Date = "12 March"
  }
}
