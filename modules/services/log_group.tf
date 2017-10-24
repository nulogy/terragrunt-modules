resource "aws_cloudwatch_log_group" "log_group" {
  name = "${var.environment_name}-log"
  retention_in_days = 365
}
