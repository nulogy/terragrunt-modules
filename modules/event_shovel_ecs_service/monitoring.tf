resource "aws_cloudwatch_log_metric_filter" "queue_size" {
  name           = "Event Queue Size in database"
  pattern        = "{ $.message.queue_size = * }"
  log_group_name = "${var.log_group_name}"

  metric_transformation {
    name      = "Event Queue Size in database"
    namespace = "${var.environment_name}"
    value     = "$.message.queue_size"
  }
}

resource "aws_cloudwatch_metric_alarm" "queue_size" {
  alarm_name                = "${var.environment_name}-events-queue-size"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "${var.alert_evaluation_periods}"
  metric_name               = "${aws_cloudwatch_log_metric_filter.queue_size.name}"
  namespace                 = "${var.environment_name}"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "100"
  alarm_description         = "This alarm monitors when the events queue size in the app's DB is to high. Root cause could be that the event shovel is down."
  treat_missing_data        = "breaching"
  alarm_actions             = ["${var.alert_topic_arn}"]
  insufficient_data_actions = ["${var.alert_topic_arn}"]
  ok_actions                = ["${var.alert_topic_arn}"]
}
