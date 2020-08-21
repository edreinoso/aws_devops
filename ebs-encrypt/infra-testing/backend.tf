terraform {
  backend "s3" {
    bucket         = "terraform-state-er"
    dynamodb_table = "terraform-state-lock-dynamo"
    region         = "us-east-1"
    key            = "ebs-encrypt/infra-testing.tfstate" # this would come to be the name of the file
  }
}