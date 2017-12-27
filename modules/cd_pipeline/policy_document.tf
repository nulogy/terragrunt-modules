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
      "ssm:GetParameters"
    ]

    resources = [
      "*"
    ]
  }
}
