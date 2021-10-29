locals {
  zone_name              = trimsuffix(var.environment_dns_zone_name, ".")
  kafka_connect_dns_name = "${local.normalized_service_name}.${local.zone_name}"
}

resource "aws_ecs_service" "restarter" {
  name            = "${local.normalized_service_name}-restarter"
  cluster         = var.ecs_cluster_name
  task_definition = aws_ecs_task_definition.restarter.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets         = module.vpc.private_subnet_ids
    security_groups = [aws_security_group.app_worker.id]
  }
}

module "log_group" {
  source = "git::https://github.com/nulogy/terragrunt-modules//modules/log_group"
  name   = "${local.normalized_service_name}-kafka-connect-restarter-task"
}

resource "aws_ecs_task_definition" "restarter" {
  family                   = "${local.normalized_service_name}-kafka-connect-restarter"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_executionrole.arn
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  container_definitions    = <<TASK_DEFINITION
  [
    {
      "environment": [
        {"name": "CONNECT_URL", "value": "https://${local.kafka_connect_dns_name}"}
      ],
      "essential": true,
      "image": "nulogy/kafka-connect-restarter:1.0.5",
      "name": "restarter",
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${module.log_group.log_group_name}",
          "awslogs-region": "${var.aws_region}",
          "awslogs-stream-prefix": "${local.normalized_service_name}-restarter"
        }
      }
    }
  ]
  TASK_DEFINITION
}

resource "aws_iam_role" "ecs_executionrole" {
  name               = "${local.normalized_service_name}-ecs-restarter-execution-role"
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
  name   = "${local.normalized_service_name}-fargate-ecs-restarter-task-execution"
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

resource "aws_security_group" "app_worker" {
  name   = "${local.normalized_service_name} restarter"
  vpc_id = module.vpc.vpc_id

  tags = {
    Name           = "${local.normalized_service_name} restarter"
    resource_group = local.normalized_service_name
  }

}

resource "aws_security_group_rule" "app_allow_egress_to_everywhere" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  security_group_id = aws_security_group.app_worker.id

  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "app_allow_egress_to_everywhere_ipv6" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  security_group_id = aws_security_group.app_worker.id

  ipv6_cidr_blocks = ["::/0"]
}

resource "aws_security_group_rule" "app_allow_ingress_from_vpc" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  security_group_id = aws_security_group.app_worker.id

  cidr_blocks = [module.vpc.vpc_cidr]
}
