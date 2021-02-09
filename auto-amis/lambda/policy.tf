resource "aws_iam_role" "role" {
  name = "auto-amis-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Name          = "auto-amis-role"
    Template      = "devops"
    Environment   = terraform.workspace
    Application   = "auto ami automation"
    Purpose       = "role for the functions to assume and execute operations"
    Creation_Date = "Jan 1st"
  }
}

resource "aws_iam_policy" "policy" {
  name        = "auto-amis-policy"
  description = "Policy to grant permissions for functions to execute the auto amis automation script"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "dynamodb:PutItem",
                "dynamodb:Scan",
                "dynamodb:Query",
                "dynamodb:GetShardIterator",
                "dynamodb:DescribeStream",
                "dynamodb:GetRecords",
                "dynamodb:ListStreams"
            ],
            "Resource": [
              "arn:aws:dynamodb:us-east-1:130193131803:table/${var.table-name}",
              "arn:aws:dynamodb:us-east-1:130193131803:table/${var.table-name}/stream/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        },
        {
            "Action": "ec2:*",
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy_attachment" "test-attach" {
  name       = "attachment"
  roles      = [aws_iam_role.role.name]
  policy_arn = aws_iam_policy.policy.arn
}
