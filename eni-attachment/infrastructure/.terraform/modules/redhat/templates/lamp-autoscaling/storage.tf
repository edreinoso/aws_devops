resource "aws_s3_bucket" "s3" {
  bucket        = var.bucket-name
  acl           = var.acl
  force_destroy = var.destroy

  policy = <<POLICY
{
  "Id": "Policy1566872708101",
  "Version": "2012-10-17",
  "Statement": [
      {
          "Sid": "Stmt1566872706748",
          "Action": [
              "s3:PutObject"
          ],
          "Effect": "Allow",
          "Resource": "arn:aws:s3:::${var.bucket-name}/AWSLogs/${var.account-id}/*",
          "Principal": {
              "AWS": [
                  "127311923021"
              ]
          }
      }
  ]
}
POLICY

  tags = {
    Name            = var.bucket-name
    Environment     = terraform.workspace
    Template        = var.template
    Application     = var.application
    Purpose         = var.purpose
    Creation_Date   = var.created-on
  }
}
