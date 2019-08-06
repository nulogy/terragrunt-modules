data "aws_caller_identity" "current" {
}

resource "aws_iam_instance_profile" "rabbitmq_profile" {
  name = "${var.environment_name}-rabbitmq-profile"
  role = aws_iam_role.rabbitmq_role.name
}

resource "aws_iam_role" "rabbitmq_role" {
  name = "${var.environment_name}-rabbitmq-role"

  lifecycle {
    create_before_destroy = true
  }

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF

}

resource "aws_iam_role_policy" "parameter_store_policy" {
  name   = "${var.environment_name}-rabbitmq-parameter-store"
  role   = aws_iam_role.rabbitmq_role.id
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
        "ssm:*"
      ],
      "Resource": [
        "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/${var.environment_name}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "kms:Decrypt"
      ],
      "Resource": [
        "arn:aws:kms:${var.aws_region}:${data.aws_caller_identity.current.account_id}:key/${var.kms_key_id}"
      ]
    }
  ]
}
EOF

}

resource "aws_iam_role_policy" "describe_instances_policy" {
  name   = "${var.environment_name}-rabbitmq-describe-instances"
  role   = aws_iam_role.rabbitmq_role.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeInstances",
                "autoscaling:DescribeAutoScalingInstances"
            ],
            "Resource": "*"
        }
    ]
}
EOF

}

