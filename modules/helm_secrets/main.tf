data "aws_caller_identity" "current" {}

resource "aws_kms_key" "helm_secrets" {
  description = "Key for encryption/decryption of secrets via helm secrets plugin/Mozilla SOPS"
  enable_key_rotation = true
  multi_region = true

  lifecycle {
    prevent_destroy = true
  }

  # TODO: right now developer SSO roles have unfettered access to account
  # in the future we may create multiple classes of users, where the less
  # privileged class will have key access, and the privileged class admin access.
  # Define both admin and usage access here so we just need to swap out roles later.
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid = "Enable IAM policies",
        Effect = "Allow",
        Principal = {
          "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action = "kms:*",
        Resource = "*"
      },
      {
        Sid = "Allow access for Administrators",
        Effect = "Allow",
        Principal = {
          "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-reserved/sso.amazonaws.com/${var.admin_sso_role}"
        },
        Action = [
          "kms:Create*",
          "kms:Describe*",
          "kms:Enable*",
          "kms:List*",
          "kms:Put*",
          "kms:Update*",
          "kms:Revoke*",
          "kms:Disable*",
          "kms:Get*",
          "kms:Delete*",
          "kms:TagResource",
          "kms:UntagResource",
          "kms:ScheduleKeyDeletion",
          "kms:CancelKeyDeletion"
        ],
        Resource = "*"
      },
      {
        Sid = "Allow access for Developers",
        Effect = "Allow",
        Principal = {
          "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-reserved/sso.amazonaws.com/${var.developer_sso_role}"
        },
        Action = [
          "kms:Create*",
          "kms:Describe*",
          "kms:Enable*",
          "kms:List*",
          "kms:Put*",
          "kms:Update*",
          "kms:Revoke*",
          "kms:Disable*",
          "kms:Get*",
          "kms:Delete*",
          "kms:TagResource",
          "kms:UntagResource",
          "kms:ScheduleKeyDeletion",
          "kms:CancelKeyDeletion"
        ],
        Resource = "*"
      },
      {
        Sid = "Allow use of the key",
        Effect = "Allow",
        Principal = {
          "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-reserved/sso.amazonaws.com/${var.developer_sso_role}"
        },
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        Resource = "*"
      },
      {
        Sid = "Allow attachment of persistent resources",
        Effect = "Allow",
        Principal = {
          "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-reserved/sso.amazonaws.com/${var.developer_sso_role}"
        },
        Action = [
          "kms:CreateGrant",
          "kms:ListGrants",
          "kms:RevokeGrant"
        ],
        Resource = "*",
        Condition = {
          "Bool": {
            "kms:GrantIsForAWSResource": "true"
          }
        }
      }
    ]
  })
}

resource "aws_kms_alias" "kms_alias" {
  name          = "alias/${var.environment_name}-helm-secrets"
  target_key_id = aws_kms_key.helm_secrets.key_id
}