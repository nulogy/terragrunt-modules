data "aws_caller_identity" "current" {
}

resource "aws_kms_key" "kms_key" {
  enable_key_rotation = true

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Id": "key-default-1",
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        ]
      },
      "Action": "kms:*",
      "Resource": "*"
    }
  ]
}
EOF

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_kms_alias" "kms_alias" {
  name          = "alias/${var.environment_name}"
  target_key_id = aws_kms_key.kms_key.key_id
}

