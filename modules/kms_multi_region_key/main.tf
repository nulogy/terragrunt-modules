data "aws_caller_identity" "current" {}

# https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-overview.html
data "aws_iam_policy_document" "policy" {
  statement {
    sid = "Enable IAM policies"
    principals {
      type = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions = ["kms:*"]
    resources = ["*"]
  }

  statement {
    sid = "Allow access for Key Administrators"
    principals {
      type = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-reserved/sso.amazonaws.com/${var.administrator_role}"]
    }
    actions = [
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
    ]
    resources = ["*"]
  }

  statement {
    sid = "Allow use of the key"
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-reserved/sso.amazonaws.com/${var.administrator_role}",
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-reserved/sso.amazonaws.com/${var.developer_role}"
      ]
    }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]
  }

  statement {
    sid = "Allow attachment of persistent resources"
    principals {
      type = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant"
    ]
    resources = ["*"]
    condition {
      test = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values = ["true"]
    }
  }
}

resource "aws_kms_key" "primary" {
  description         = "${var.description}"
  enable_key_rotation = true
  multi_region        = true

  lifecycle {
    prevent_destroy = true
  }

  policy = data.aws_iam_policy_document.policy.json
}

resource "aws_kms_alias" "kms_alias" {
  name          = "alias/${var.environment_name}"
  target_key_id = aws_kms_key.primary.key_id
}

resource "aws_kms_replica_key" "replica" {
  provider        = aws.replica
  description     = "${var.description}"
  primary_key_arn = aws_kms_key.primary.arn
  policy          = data.aws_iam_policy_document.policy.json
}

resource "aws_kms_alias" "replica" {
  provider      = aws.replica
  name          = "alias/${var.environment_name}"
  target_key_id = aws_kms_replica_key.replica.key_id
}