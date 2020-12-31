terraform {
  backend "s3" {
    bucket         = "terraform-state-er"
    dynamodb_table = "terraform-state-lock-dynamo"
    region         = "us-east-1"
    key            = "auto-amis/lambda.tfstate" # this would come to be the name of the file
  }
}