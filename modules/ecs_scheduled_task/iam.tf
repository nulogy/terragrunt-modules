resource "aws_iam_role" "ecs_eventrole" {
  count = "${length(var.skip) > 0 ? 0 : 1}"

  name_prefix = "ecs-event-${var.environment_name}-"
  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}