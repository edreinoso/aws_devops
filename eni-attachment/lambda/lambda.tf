module "function" {
  source        = "github.com/edreinoso/terraform_infrastructure_as_code/modules/compute/lambda"
  file-name     = var.file-name-eni
  function-name = var.function-name-eni
  description   = var.description
  role          = "arn:aws:iam::130193131803:role/eni_attachment"
  handler       = "function.${var.handler}"
  runtime       = var.runtime
  timeout       = var.timeout
  memory-size   = var.memory-size
#   layers        = [aws_lambda_layer_version.lambda_layer.arn]
  tags = {
    "Name"        = var.function-name-eni
    Environment   = terraform.workspace
    Template      = "devops"
    Application   = "eni attachment automation"
    Purpose       = "lambda function to attach secondary enis"
    Creation_Date = "Aug 3rd"
  }
}
