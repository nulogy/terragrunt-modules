resource "aws_iam_user" "user" {
  name = "${var.environment_name}-env-deployer"
}

resource "aws_iam_group" "group" {
  name = "${var.environment_name}-env-deployer"
}

resource "aws_iam_group_membership" "group-membership" {
  name = "${var.environment_name}-env-group-membership"

  users = ["${aws_iam_user.user.name}"]

  group = "${aws_iam_group.group.name}"
}
