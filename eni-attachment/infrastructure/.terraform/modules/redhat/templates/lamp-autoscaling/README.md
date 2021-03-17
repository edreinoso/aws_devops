### Template 2 - Deploying a LAMP stack with autoscaling

![architecture-2](https://s3.amazonaws.com/personal-website-assets104410-dev/projects/template-2-autoscaling.png)

This template package provides a simple 2 tier architecture that deployes a Network stack, Compute stack and a Security stack. This is the layout:

Network Stack:
- VPC
- 4 HA subnets
  - Public (a & b)
  - Web (a & b)
  - App (a & b)
  - DB (a & b)
- RT
  - Routes (pubs and pri)
  - RT Associations
- IGW

Security Resources:
- SG ALB
- SG Nat
- SG Web

Compute Stack:
- ALB
  - target groups
  - target group attachment
  - listeners
- 2 Servers
  - Bastion host NAT
  - HTTP Autoscaling server (with build script)

Storage:
- S3 bucket for load balancer logs

NOTE: everything is going to be deployed at once!