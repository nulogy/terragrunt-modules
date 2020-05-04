data "aws_caller_identity" "current" {
}

resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/event_shovel/${var.environment_name}"
  retention_in_days = "30"
}

module "event_shovel" {
  source = "../../modules/event_shovel_ecs_service"

  alert_topic_arn          = var.notification_topic_arn
  alert_evaluation_periods = var.alert_evaluation_periods
  aws_account              = data.aws_caller_identity.current.account_id
  aws_region               = var.aws_region
  kms_key_id               = var.kms_key_id
  desired_count            = 1
  docker_image_name        = "${module.ecr.ecr_url}:${var.docker_build_tag}"
  ecs_cluster_name         = var.ecs_cluster_name
  environment_name         = var.environment_name
  envvars                  = <<ENVVARS
[
  {
    "name": "AWS_DEFAULT_REGION",
    "value": "${var.aws_region}"
  },
  {
    "name": "ENVIRONMENT_NAME",
    "value": "${var.environment_name}"
  },
  {
    "name": "EVENT_SHOVEL_MONITORING_APP_NAME",
    "value": "${var.environment_name}"
  },
  {
    "name": "EVENT_SHOVEL_POSTGRES_HOST",
    "value": "${var.overridden_db_hostname}"
  },
  {
    "name": "EVENT_SHOVEL_POSTGRES_USER",
    "value": "${var.overridden_db_user}"
  },
  {
    "name": "EVENT_SHOVEL_POSTGRES_DBNAME",
    "value": "${var.overridden_db_name}"
  },
  {
    "name": "EVENT_SHOVEL_AMQP_HOST",
    "value": "${var.amqp_host}"
  },
  {
    "name": "EVENT_SHOVEL_AMQP_USER",
    "value": "${var.amqp_user}"
  },
  {
    "name": "EVENT_SHOVEL_AMQP_EXCHANGE_NAME",
    "value": "${var.amqp_exchange_name}"
  },
  {
    "name": "EVENT_SHOVEL_AMQP_TLS",
    "value": "true"
  }
]
ENVVARS


  log_group_name        = aws_cloudwatch_log_group.log_group.name
  param_store_namespace = var.environment_name
  private_subnet_ids    = var.private_subnet_ids
  vpc_id                = var.vpc_id
}

