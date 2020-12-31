# claiming an inline policy for lambda to manipulate the stream
resource "aws_iam_role_policy" "lambda_policy" {
  name = "ddb_streams_auto_ami"
  role = "${var.roleName}"

  policy = <<-EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Sid": "VisualEditor0",
          "Effect": "Allow",
          "Action": [
                "dynamodb:DescribeStream",
                "dynamodb:GetRecords",
                "dynamodb:GetShardIterator",
                "dynamodb:ListStreams"
          ], 
          "Resource": "arn:aws:dynamodb:us-east-1:130193131803:table/${var.table-name}/stream/*"
      }
  ]
}
  EOF
}