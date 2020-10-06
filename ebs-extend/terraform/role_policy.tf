# resource "aws_iam_role_policy" "lambda_policy" {
#   name = "lambda_policy_ssm"
#   role = "${var.role}"

#   policy = <<-EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#       {
#           "Sid": "VisualEditor0",
#           "Effect": "Allow",
#           "Action": "ssm:SendCommand",
#           "Resource": [
#               "arn:aws:ssm:us-east-1:130193131803:document/extend_ebs_volume",
#               "arn:aws:ec2:us-east-1:130193131803:instance/${aws_instance.ec2.id}"
#           ]
#       }
#   ]
# }
#   EOF
# }
