resource "aws_sns_topic" "topic" {
  name = "${var.topic_name}"

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_sns_topic_subscription" "https_topic_sub" {
  count = "${length(var.https_subscription_endpoint) > 0 ? 1 : 0}"

  endpoint = "${var.https_subscription_endpoint}"
  protocol = "https"
  topic_arn = "${aws_sns_topic.topic.arn}"
}