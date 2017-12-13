resource "aws_iam_role" "ecs_eventrole" {
  count = "${length(var.skip) > 0 ? 0 : 1}"

  name_prefix = "schedule-task-${var.environment_name}-"
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

resource "aws_iam_role_policy" "test_schedule_policy" {
  name = "schedule-task-${var.environment_name}"
  role = "${aws_iam_role.ecs_eventrole.id}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecs:RunTask"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
}
