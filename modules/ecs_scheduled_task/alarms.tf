resource "aws_cloudwatch_metric_alarm" "scheduled_task_failed_invocation_alarm" {
  alarm_name                = "${var.environment_name}-${var.task_name}-scheduled_task_failed_invocation"
  alarm_description         = "This alarm monitors ${var.environment_name} scheduled task failed invocations. It monitors if there was at least one failed invocation in the last evaluation period."
  period                    = "60" // = 1 min. We don't need a high-resolution alarm (< 30 seconds). Note: High-resolution alarms are more expensive
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "FailedInvocations"
  namespace                 = "AWS/Events"
  statistic                 = "SampleCount"
  threshold                 = "0"
  treat_missing_data        = "notBreaching"
  alarm_actions             = [var.alert_topic_arn]
  insufficient_data_actions = [var.alert_topic_arn]
  ok_actions                = [var.alert_topic_arn]

  dimensions = {
    RuleName = aws_cloudwatch_event_rule.scheduled_task_event_rule[0].name
  }
}

resource "aws_cloudwatch_metric_alarm" "scheduled_task_invocations_alarm" {
  alarm_name                = "${var.environment_name}-${var.task_name}-scheduled_task_invocations"
  alarm_description         = "This alarm monitors ${var.environment_name} scheduled task invocations. It monitors if there was at least one invocations in the last evaluation period."
  period                    = "300" // = 5 mins. We don't need a high-resolution alarm (< 30 seconds). Note: High-resolution alarms are more expensive
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = "288" // eval_periods * period = 86400 seconds = 1 day
  metric_name               = "Invocations"
  namespace                 = "AWS/Events"
  statistic                 = "SampleCount"
  threshold                 = "1"
  treat_missing_data        = "breaching"
  alarm_actions             = [var.alert_topic_arn]
  insufficient_data_actions = [var.alert_topic_arn]
  ok_actions                = [var.alert_topic_arn]

  dimensions = {
    RuleName = aws_cloudwatch_event_rule.scheduled_task_event_rule[0].name
  }
}

