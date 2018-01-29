resource "aws_cloudwatch_log_metric_filter" "queue_size" {
  name           = "GO Events Queue Size"
  pattern        = "{ $.message.queue_size = * }"
  log_group_name = "${var.log_group_name}"

  metric_transformation {
    name      = "GO Events Queue Size"
    namespace = "${var.environment_name}-event-shovel"
    value     = "$.message.queue_size"
  }
}
