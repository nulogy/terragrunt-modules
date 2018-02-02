# https://github.com/18F/fec-infrastructure/commit/f52d22caf5e90e6d3da914aff87057bd272fbb4e
resource "aws_iam_role" "monitoring" {
  name = "${var.environment_name}-db-monitoring-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "monitoring.rds.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "monitoring" {
  role       = "${aws_iam_role.monitoring.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}
