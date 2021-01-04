resource "aws_iam_role" "role" {
  name = "${var.ebs-encryption-iam}_role"

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
    Name          = "${var.ebs-encryption-iam}_role"
    Environment   = "none"
    Template      = "devops"
    Application   = "ebs-encryption"
    Purpose       = "Role for the functions to execute the volume encryption"
    Creation_Date = "Jan_3rd_2021"
  }
}

resource "aws_iam_policy" "policy" {
  name        = "${var.ebs-encryption-iam}_policy"
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
                "dynamodb:UpdateItem",
                "dynamodb:GetRecords"
            ],
            "Resource": [
              "arn:aws:dynamodb:us-east-1:130193131803:table/${var.table-name}"
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

resource "aws_iam_policy_attachment" "policy-attach" {
  name       = "attachment"
  roles      = [aws_iam_role.role.name]
  policy_arn = aws_iam_policy.policy.arn
}
