data "aws_caller_identity" "current" {}
data "aws_region" "current" {
  current = true
}

data "aws_iam_policy_document" "deployer_policy_document" {
  count = "${var.skip == true ? 0 : 1}"

  statement {
    actions = [
      "cloudwatch:DescribeAlarms",
      "ec2:Describe*",
      "ecr:BatchGetImage",
      "ecr:DescribeRepositories",
      "ecr:GetAuthorizationToken",
      "ecr:GetDownloadUrlForLayer",
      "ecs:DeregisterTaskDefinition",
      "ecs:DescribeClusters",
      "ecs:DescribeServices",
      "ecs:DescribeTaskDefinition",
      "ecs:RegisterTaskDefinition",
      "ecs:UpdateService",
      "elasticloadbalancing:DescribeTags",
      "elasticloadbalancing:DescribeTargetGroupAttributes",
      "elasticloadbalancing:DescribeTargetGroups",
      "events:DescribeRule",
      "events:ListTargetsByRule",
      "iam:GetRole",
      "iam:GetRolePolicy",
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:GetKeyPolicy",
      "kms:GetKeyRotationStatus",
      "kms:ListResourceTags",
      "logs:DescribeLogGroups",
      "logs:ListTagsLogGroup",
      "SNS:GetTopicAttributes",
    ]

    resources = [
      "*"
    ]
  }

  statement {

    actions = [
      "s3:Get*",
      "s3:List*",
      "s3:PutObject"
    ]

    resources = [
      "arn:aws:s3:::${var.environment_name}-terraform-state",
      "arn:aws:s3:::${var.environment_name}-terraform-state/*"
    ]
  }

  statement {
    actions = [
      "s3:PutObject"
    ]

    resources = [
      "arn:aws:s3:::${var.environment_name}-static-assets/*"
    ]
  }

  statement {
    actions = [
      "dynamodb:DescribeTable",
      "dynamodb:PutItem",
      "dynamodb:GetItem",
      "dynamodb:DeleteItem"
    ]

    resources = [
      "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${var.environment_name}-lock-table"
    ]
  }

  statement {
    actions = ["iam:PassRole"]
    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ecs-task-${var.environment_name}-*",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/schedule-task-${var.environment_name}-*"
    ]
  }

  statement {
    actions = ["events:PutTargets"]
    resources = [
      "arn:aws:events:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:rule/${var.environment_name}_*_scheduled_task_event_rule"
    ]
  }

  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart"
    ]
    resources = [
      "arn:aws:ecr:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:repository/${var.environment_name}"
    ]
  }
}
