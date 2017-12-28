resource "aws_iam_user" "user" {
  name = "${var.environment_name}-env-deployer"
}

// This group should only be able to deploy GO (no access to prepare)
resource "aws_iam_group" "group" {
  name = "${var.environment_name}-env-deployer"
}

resource "aws_iam_group_membership" "group_membership" {
  name = "${var.environment_name}-env-group-membership"

  users = ["${aws_iam_user.user.name}"]

  group = "${aws_iam_group.group.name}"
}

resource "aws_iam_group_policy_attachment" "policy_attachment" {
  group      = "${aws_iam_group.group.name}"
  policy_arn = "${aws_iam_policy.deployer_iam_policy.arn}"
}

resource "aws_iam_policy" "deployer_iam_policy" {
  path   = "/"
  policy = "${data.aws_iam_policy_document.deployer_policy_document.json}"
}
