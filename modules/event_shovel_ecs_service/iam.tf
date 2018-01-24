resource "aws_iam_role" "ecs_taskrole" {
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

resource "aws_iam_role_policy" "parameter_store_policy" {
  name = "${var.environment_name}-event-shovel-parameter-store"
  role = "${aws_iam_role.ecs_taskrole.id}"
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
        "ssm:GetParameter"
      ],
      "Resource": [
        "arn:aws:ssm:${var.aws_region}:${var.aws_account}:parameter/${var.environment_name}/*"
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
