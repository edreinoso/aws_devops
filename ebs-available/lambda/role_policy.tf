data "terraform_remote_state" "ec2" {
  backend = "s3"
  config = {
    bucket = "terraform-state-er"
    key    = "env:/dev/ebs-available/ec2.tfstate"
    region = "us-east-1"
  }
}


resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_policy_ssm"
  role = "${var.roleName}"

  policy = <<-EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Sid": "VisualEditor0",
          "Effect": "Allow",
          "Action": "ssm:SendCommand",
          "Resource": [
              "arn:aws:ssm:us-east-1:130193131803:document/ebs_available",
              "arn:aws:ec2:us-east-1:130193131803:instance/${element(element(element(data.terraform_remote_state.ec2.outputs.id, 0), 0), 0)}"
          ]
      }
  ]
}
  EOF
}
