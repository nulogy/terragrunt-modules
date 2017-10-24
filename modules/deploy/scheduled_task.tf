resource "aws_cloudwatch_event_rule" "scheduled_task_event_rule" {
  name = "${var.environment_name}_scheduled_task_event_rule"
  description = "This event rule runs the GO scheduled task"

  schedule_expression = "cron(00 09 * * ? *)"
}

resource "aws_cloudwatch_event_target" "scheduled_task_event_target" {
  arn = "${aws_ecs_service.ecs_service.cluster}"
  rule = "${aws_cloudwatch_event_rule.scheduled_task_event_rule.name}"
  role_arn = "${aws_iam_role.ecs_eventrole.arn}"
  input = <<JSON
    {
      "containerOverrides": [
        {
          "name": "${var.environment_name}",
          "command": ["bundle","exec","rake","order_tracking:process_data"]
        }
      ]
    }
  JSON

  ecs_target {
    task_definition_arn = "${aws_ecs_task_definition.go_task.arn}"
    task_count = 1
  }
}

// Terraform does not support 'email' topic subscription (see https://www.terraform.io/docs/providers/aws/r/sns_topic_subscription.html#email)
// We will assume a "go-team-alerts" topic subscription was already created
data "aws_sns_topic" "alert_topic" {
  name = "${var.alerts_topic_name}"
}

resource "aws_cloudwatch_metric_alarm" "scheduled_task_failed_invocation_alarm" {
  alarm_name = "${var.environment_name}-scheduled_task_failed_invocation"
  alarm_description = "This alarm monitors ${var.environment_name} scheduled task failed invocations. It monitors if there was at least one failed invocation in the last evaluation period."
  period = "60" // = 1 min. We don't need a high-resolution alarm (< 30 seconds). Note: High-resolution alarms are more expensive
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods = "1"
  metric_name = "FailedInvocations"
  namespace = "AWS/Events"
  statistic = "SampleCount"
  threshold = "0"
  treat_missing_data = "notBreaching"
  alarm_actions = ["${data.aws_sns_topic.alert_topic.arn}"]
  insufficient_data_actions = ["${data.aws_sns_topic.alert_topic.arn}"]

  dimensions {
    RuleName = "${aws_cloudwatch_event_rule.scheduled_task_event_rule.name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "scheduled_task_invocations_alarm" {
  alarm_name = "${var.environment_name}-scheduled_task_invocations"
  alarm_description = "This alarm monitors ${var.environment_name} scheduled task invocations. It monitors if there was at least one invocations in the last evaluation period."
  period = "300" // = 5 mins. We don't need a high-resolution alarm (< 30 seconds). Note: High-resolution alarms are more expensive
  comparison_operator = "LessThanThreshold"
  evaluation_periods = "288" // eval_periods * period = 86400 seconds = 1 day
  metric_name = "Invocations"
  namespace = "AWS/Events"
  statistic = "SampleCount"
  threshold = "1"
  treat_missing_data = "breaching"
  alarm_actions = ["${data.aws_sns_topic.alert_topic.arn}"]
  insufficient_data_actions = ["${data.aws_sns_topic.alert_topic.arn}"]

  dimensions {
    RuleName = "${aws_cloudwatch_event_rule.scheduled_task_event_rule.name}"
  }
}
