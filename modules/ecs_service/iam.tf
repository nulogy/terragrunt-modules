resource "aws_iam_role" "ecs_servicerole" {
  count = "${length(var.skip) > 0 ? 0 : 1}"

  name_prefix = "ecs-service-${var.environment_name}-"
  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ecs_servicerole_policy" {
  count = "${length(var.skip) > 0 ? 0 : 1}"

  name_prefix = "ecs-service-policy-${var.environment_name}"
  role = "${aws_iam_role.ecs_servicerole.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "elasticloadbalancing:Describe*",
        "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
        "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
        "elasticloadbalancing:DeregisterTargets",
        "elasticloadbalancing:RegisterTargets",
        "ec2:Describe*",
        "ec2:AuthorizeSecurityGroupIngress"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role" "ecs_taskrole" {
  count = "${length(var.skip) > 0 ? 0 : 1}"

  name_prefix = "ecs-task-${var.environment_name}-"
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
  count = "${length(var.skip) > 0 ? 0 : (length(var.kms_key_id) > 0 ? 1 : 0)}"

  name_prefix = "parameter-store-policy-${var.environment_name}"
  role = "${aws_iam_role.ecs_taskrole.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameter"
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