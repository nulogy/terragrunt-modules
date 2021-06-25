module "log_group" {
  source = "../../modules/log_group"

  name = "${var.environment_name}-${var.service_name}"
}

module "public_load_balancer" {
  source = "../../modules/public_load_balancer_blue_green"

  alb_subnets                      = var.public_subnets
  cert_domain                      = var.cert_domain
  deregistration_delay             = var.deregistration_delay
  environment_name                 = var.environment_name
  health_check_path                = var.health_check_path
  health_check_timeout             = var.health_check_timeout
  internal                         = var.internal
  ip_address_type                  = var.lb_ip_address_type
  lb_cert_arn                      = var.lb_cert_arn
  lb_maintenance_mode              = var.lb_maintenance_mode
  lb_maintenance_mode_content_type = var.lb_maintenance_mode_content_type
  lb_maintenance_mode_page_content = var.lb_maintenance_mode_page_content
  lb_maintenance_mode_status_code  = var.lb_maintenance_mode_status_code
  port                             = var.container_port
  security_group_ids               = var.lb_security_group_ids
  slow_start                       = var.slow_start
  stickiness_enabled               = var.stickiness_enabled
  target_type                      = "ip" # Hardcoded because `ip` is the only mode supported by fargate
  vpc_id                           = var.vpc_id
}

module "ecs_service_fargate_elb" {
  source = "../../modules/ecs_service_fargate_elb"

  command               = var.command
  container_port        = var.container_port
  cpu                   = var.cpu
  datadog_enabled       = var.datadog_enabled
  datadog_agent_version = var.datadog_agent_version
  datadog_env           = var.datadog_env
  desired_count         = var.desired_count
  docker_image_name     = var.docker_image_name
  ecs_cluster_name      = var.ecs_cluster_name
  envars                = var.envars
  environment_name      = var.environment_name
  kms_key_id            = var.kms_key_id
  log_group_name        = module.log_group.log_group_name
  memory                = var.memory
  param_store_namespace = var.param_store_namespace
  security_group_name   = var.security_group_name
  service_name          = var.service_name
  subnets               = var.private_subnets
  target_group_arn      = module.public_load_balancer.target_group_arn
  vpc_cidr              = length(var.ecs_incoming_allowed_cidr) > 0 ? var.ecs_incoming_allowed_cidr : var.vpc_cidr
  vpc_id                = var.vpc_id

  depends_on_hack = module.public_load_balancer.aws_lb_listener
}

resource "aws_iam_role" "service_role" {
  name = "${var.environment_name}-codedeploy-service-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployRoleForECS" {
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
  role       = aws_iam_role.service_role.name
}

resource "aws_codedeploy_app" "codedeploy_app" {
  compute_platform = "ECS"
  name             = "${var.environment_name}-app"
}

resource "aws_codedeploy_deployment_group" "deployment_group" {
  app_name               = aws_codedeploy_app.codedeploy_app.name
  deployment_group_name  = "${var.environment_name}-deployment-group"
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  service_role_arn       = aws_iam_role.service_role.arn

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = var.ecs_cluster_name
    service_name = module.ecs_service_fargate_elb.ecs_service_name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [module.public_load_balancer.aws_lb_listener]
      }

      target_group {
        name = module.public_load_balancer.target_group_blue_name
      }

      target_group {
        name = module.public_load_balancer.target_group_green_name
      }
    }
  }
}
