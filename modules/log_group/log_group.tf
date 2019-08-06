resource "aws_cloudwatch_log_group" "log_group" {
  count = length(var.skip) > 0 ? 0 : 1

  name              = var.name
  retention_in_days = var.retention_in_days
}

