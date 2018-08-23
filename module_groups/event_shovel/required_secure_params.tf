# Use data resources to ensure that required SSM params exist; we don't actually care about their values - we just want to crash terraform when they're not set, so that a human operator can set them ahead of time.

data "aws_ssm_parameter" "event_shovel_amqp_cert" {
  name = "/${var.environment_name}/event-shovel/EVENT_SHOVEL_AMQP_TLS_CERT"
}
data "aws_ssm_parameter" "event_shovel_amqp_key" {
  name = "/${var.environment_name}/event-shovel/EVENT_SHOVEL_AMQP_TLS_KEY"
}
data "aws_ssm_parameter" "event_shovel_amqp_pass" {
  name = "/${var.environment_name}/event-shovel/EVENT_SHOVEL_AMQP_PASS"
}
data "aws_ssm_parameter" "event_shovel_postgres_password" {
  name = "/${var.environment_name}/event-shovel/EVENT_SHOVEL_POSTGRES_PASSWORD"
}
