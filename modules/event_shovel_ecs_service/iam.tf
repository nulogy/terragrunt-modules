resource "aws_iam_role" "ecs_taskrole" {
  count = length(var.skip) > 0 ? 0 : 1

  name = "${var.environment_name}-event-shovel-ecs-task"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

}

resource "aws_iam_role" "ecs_executionrole" {
  # Warning: load bearing string!
  # Role names matching this pattern are permitted to download the image from the shared event shovel docker repo
  # hosted in CPI production's environment. If you want to change this role name, you'll need to coordinate with CPI's
  # maintainers to ensure that the new name also is permitted.
  name               = "${var.environment_name}-ecs-event-shovel-execution-role"
  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

}

resource "aws_iam_role_policy" "fargate_task_execution_role_policy" {
  name   = "${var.environment_name}-fargate-ecs-event-shovel-task-execution"
  role   = aws_iam_role.ecs_executionrole.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    }
  ]
}
EOF

}

resource "aws_iam_role_policy" "parameter_store_policy" {
  count = length(var.skip) > 0 ? 0 : 1

  name   = "${var.environment_name}-event-shovel-parameter-store"
  role   = aws_iam_role.ecs_taskrole[0].id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ssm:DescribeParameters"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameter",
        "ssm:GetParameters"
      ],
      "Resource": [
        "arn:aws:ssm:${var.aws_region}:${var.aws_account}:parameter/${var.param_store_namespace}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "kms:Decrypt"
      ],
      "Resource": [
        "arn:aws:kms:${var.aws_region}:${var.aws_account}:key/${var.kms_key_id}"
      ]
    }
  ]
}
EOF

}
