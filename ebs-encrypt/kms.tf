resource "aws_kms_key" "a" {
  description             = "${var.key-description}"
}

resource "aws_kms_grant" "a" {
  name              = "granting-permissions"
  key_id            = aws_kms_key.a.key_id
  grantee_principal = aws_iam_role.role.arn
  operations        = ["Encrypt", "Decrypt", "GenerateDataKey"]
}

resource "aws_kms_alias" "a" {
  name          = "alias/ebs-encryption"
  target_key_id = aws_kms_key.a.key_id
}