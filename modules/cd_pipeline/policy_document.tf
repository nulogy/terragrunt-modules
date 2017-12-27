data "aws_caller_identity" "current" {}
data "aws_region" "current" {
  current = true
}

data "aws_iam_policy_document" "deployer_policy_document" {
  statement {
    sid = "1"

    actions = [
      "cloudhsm:ListAvailableZones",
      "cloudwatch:DescribeAlarms",
      "ec2:Describe*",
      "ecr:DescribeRepositories",
      "ecs:DescribeClusters",
      "ecs:DescribeServices",
      "ecs:DescribeTaskDefinition",
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
      "ssm:GetParameters",
      "ecs:DeregisterTaskDefinition",
      "ecs:RegisterTaskDefinition",
      "ecs:UpdateService"
    ]

    resources = [
      "*"
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
      "arn:aws:events:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:rule/${var.environment_name}_order_tracking_process_scheduled_task_event_rule"
    ]
  }
}
