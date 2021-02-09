# packaging latest version of boto3 into a layer
# this will be needed for the function to execute
# the latest features of the method calls
resource "aws_lambda_layer_version" "lambda_layer" {
  filename   = "boto3-layer/aws-boto-layer.zip"
  layer_name = "Python-Boto3"

  compatible_runtimes = ["python2.7"]
}

# function taker
module "taker_function" {
  source        = "github.com/edreinoso/terraform_infrastructure_as_code/modules/compute/lambda"
  file-name     = var.file-name-taker
  function-name = var.function-name-taker
  role          = aws_iam_role.role.arn
  # role          = var.role
  # aws_iam_role.role.arn
  handler       = "taker_function.${var.handler}"
  runtime       = var.runtime
  timeout       = var.timeout
  memory-size   = var.memory-size
  layers        = [aws_lambda_layer_version.lambda_layer.arn]
  tags = {
    "Name"        = var.function-name-taker
    Environment   = terraform.workspace
    Template      = "devops"
    Application   = "auto ami automation"
    Purpose       = "lambda function that will create amis"
    Creation_Date = "Dec 18th"
  }
}

# function cleaner
module "cleaner_function" {
  source    = "github.com/edreinoso/terraform_infrastructure_as_code/modules/compute/lambda"
  file-name = var.file-name-cleaner
  function-name = var.function-name-cleaner
  role        = aws_iam_role.role.arn
  # role        = var.role
  handler     = "cleaner_function.${var.handler}"
  runtime     = var.runtime
  timeout     = var.timeout
  memory-size = var.memory-size
  layers      = [""]
  tags = {
    "Name"        = var.function-name-cleaner
    Environment   = terraform.workspace
    Template      = "devops"
    Application   = "auto ami automation"
    Purpose       = "lambda function that will delete amis"
    Creation_Date = "Dec 19th"
  }
}
