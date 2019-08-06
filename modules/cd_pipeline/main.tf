resource "aws_iam_user" "user" {
  count = var.skip == true ? 0 : 1

  name = "${var.environment_name}-env-deployer"
}

// This group should only be able to deploy GO (no access to prepare)
resource "aws_iam_group" "group" {
  count = var.skip == true ? 0 : 1

  name = "${var.environment_name}-env-deployer"
}

resource "aws_iam_group_membership" "group_membership" {
  count = var.skip == true ? 0 : 1

  name = "${var.environment_name}-env-group-membership"

  users = [aws_iam_user.user[0].name]

  group = aws_iam_group.group[0].name
}

resource "aws_iam_group_policy_attachment" "policy_attachment" {
  count = var.skip == true ? 0 : 1

  group      = aws_iam_group.group[0].name
  policy_arn = aws_iam_policy.deployer_iam_policy[0].arn
}

resource "aws_iam_policy" "deployer_iam_policy" {
  count = var.skip == true ? 0 : 1

  path   = "/"
  policy = data.aws_iam_policy_document.deployer_policy_document[0].json
}

