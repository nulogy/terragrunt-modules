resource "aws_sns_topic" "topic" {
  name = "${var.topic_name}"

  lifecycle {
    prevent_destroy = true
  }
}
