resource "aws_cloudwatch_event_rule" "scheduled_task_event_rule" {
  count = "${length(var.skip) > 0 ? 0 : 1}"

  name = "${var.environment_name}_${var.task_name}_scheduled_task_event_rule"
  description = "This event rule runs the ${var.task_name} scheduled task"

  schedule_expression = "${var.schedule_expression}"
}

resource "aws_cloudwatch_event_target" "scheduled_task_event_target" {
  count = "${length(var.skip) > 0 ? 0 : 1}"

  arn = "${var.ecs_cluster_name}"
  rule = "${aws_cloudwatch_event_rule.scheduled_task_event_rule.name}"
  role_arn = "${aws_iam_role.ecs_eventrole.arn}"
  input = "${var.event_target_json}"

  ecs_target {
    task_definition_arn = "${var.ecs_task_arn}"
    task_count = 1
  }
}