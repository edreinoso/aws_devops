## AMI ##

  data "aws_ami" "amazon_linux" {
    most_recent = true

    owners = ["130193131803"]

    filter {
      name = "name"
      values = [
        "nat-ami-5-11",
      ]
    }
  }

## EC2 ##

  ## NAT ##
    #this module has to be configured to get the custom AMI for NAT
    module "nat-ec2" {
      source             = "github.com/edreinoso/terraform_infrastructure_as_code/modules/compute/ec2"
      ami                = data.aws_ami.amazon_linux.id
      instance-type      = var.instance-type
      public-ip          = var.public-ip-association-true
      sourceCheck        = var.sourceCheck-disable
      key-name           = var.key-name-pub
      subnet-ids         = element(module.pub_subnet_2.subnet-id, 1)
      security-group-ids = split(",", aws_security_group.nat-sg.id)
      tags = {
        Name          = "nat bastion host"
        Template      = ""
        Environment   = ""
        Application   = ""
        Purpose       = ""
        Creation_Date = ""
      }
    }


## ELB ##
  
  ### INTERNAL ###
    
    module "elb" {
      source         = "github.com/edreinoso/terraform_infrastructure_as_code/modules/compute/load-balancer/elb"
      elb-name       = var.elb-name
      internal-elb   = var.internal-elb
      elb-type       = var.elb-type
      security-group = split(",", aws_security_group.elb-sg.id)
      subnet-ids     = [element(module.pub_subnet_1.subnet-id, 1), element(module.pub_subnet_2.subnet-id, 1)]
      bucket-name    = var.bucket-name
      tags = {
        Name          = ""
        Template      = ""
        Environment   = ""
        Application   = ""
        Purpose       = ""
        Creation_Date = ""
      }
    }

    module "target-group" {
      source         = "github.com/edreinoso/terraform_infrastructure_as_code/modules/compute/load-balancer/tg"
      vpc-id         = module.new-vpc.vpc-id
      elb-tg-name    = var.elb-tg-name
      tg-port        = var.tg-port
      deregistration = var.tg-deregister
      tg-protocol    = var.tg-protocol
      tg-target-type = var.tg-target-type
      tags = {
        Name          = ""
        Template      = ""
        Environment   = ""
        Application   = ""
        Purpose       = ""
        Creation_Date = ""
      }
    }

    ## HTTP listener!
    module "http-listener" {
      source            = "github.com/edreinoso/terraform_infrastructure_as_code/modules/compute/load-balancer/listener"
      elb-arn           = module.elb.elb-arn
      listener-port     = var.tg-port
      listener-protocol = var.tg-protocol
      target-group-arn  = module.target-group.target-arn
    }

    ## HTTPS listener!
    # module "https-listener" {
    #   source            = "/Users/elchoco/aws/terraform_infrastructure_as_code/modules/compute/load-balancer/listener"
    #   elb-arn           = "${module.elb.elb-arn}"
    #   listener-port     = "${var.tg-port}"
    #   target-group-arn  = "${module.target-group.target-arn}"
    #   ssl-policy        = "${var.ssl-policy}"
    #   listener-protocol = "${var.listener-protocol}"
    #   certificate-arn   = "${var.certificate}"
    # }
  
  ### EXTERNAL ###
    
    # module "elb" {
    #   source         = "github.com/edreinoso/terraform_infrastructure_as_code/modules/compute/load-balancer/elb"
    #   elb-name       = "${var.elb-name}-internet-facing"
    #   internal-elb   = "false"
    #   elb-type       = "${var.elb-type}"
    #   security-group = "${split(",", aws_security_group.elb-sg.id)}"
    #   subnet-ids     = ["${element(module.pub_subnet_1.subnet-id,1)}","${element(module.pub_subnet_2.subnet-id,1)}"]
    #   bucket-name    = "${var.bucket-name}"
    #   tags = {
    #     Name          = ""
    #     Template      = ""
    #     Environment   = ""
    #     Application   = ""
    #     Purpose       = ""
    #     Creation_Date = ""
    #   }
    # }

    # module "target-group" {
    #   source         = "github.com/edreinoso/terraform_infrastructure_as_code/modules/compute/load-balancer/tg"
    #   elb-tg-name    = "${var.elb-tg-name}"
    #   tg-port        = "${var.tg-port}"
    #   deregistration = "${var.tg-deregister}"
    #   tg-protocol    = "${var.tg-protocol}"
    #   tg-target-type = "${var.tg-target-type}"
    #   vpc-id         = "${module.new-vpc.vpc-id}"
    #   tags = {
    #     Name          = ""
    #     Template      = ""
    #     Environment   = ""
    #     Application   = ""
    #     Purpose       = ""
    #     Creation_Date = ""
    #   }
    # }

    # ## HTTP listener!
    # module "http-listener" {
    #   source            = "github.com/edreinoso/terraform_infrastructure_as_code/modules/compute/load-balancer/listener"
    #   elb-arn           = "${module.elb.elb-arn}"
    #   listener-port     = "${var.tg-port}"
    #   listener-protocol = "${var.tg-protocol}"
    #   target-group-arn  = "${module.target-group.target-arn}"
    # }

    ## HTTPS listener!
    # module "https-listener" {
    #   source            = "/Users/elchoco/aws/terraform_infrastructure_as_code/modules/compute/load-balancer/listener"
    #   elb-arn           = "${module.elb.elb-arn}"
    #   listener-port     = "${var.tg-port}"
    #   target-group-arn  = "${module.target-group.target-arn}"
    #   ssl-policy        = "${var.ssl-policy}"
    #   listener-protocol = "${var.listener-protocol}"
    #   certificate-arn   = "${var.certificate}"
    # }