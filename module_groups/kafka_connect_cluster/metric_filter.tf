resource "aws_cloudwatch_log_metric_filter" "log-error" {
  name           = "Debezium-Errors"
  pattern        = "[date, time, level = ERROR,]"
  log_group_name = module.kafka_connect.log_group_name

  metric_transformation {
    name          = "Debezium-Errors"
    namespace     = "LogMetrics"
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_log_metric_filter" "log-info" {
  name           = "Debezium-Infos"
  pattern        = "[date, time, level = INFO,]"
  log_group_name = module.kafka_connect.log_group_name

  metric_transformation {
    name          = "Debezium-Infos"
    namespace     = "LogMetrics"
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_log_metric_filter" "log-warn" {
  name           = "Debezium-Warnings"
  pattern        = "[date, time, level = WARN,]"
  log_group_name = module.kafka_connect.log_group_name

  metric_transformation {
    name          = "Debezium-Warnings"
    namespace     = "LogMetrics"
    value         = "1"
    default_value = "0"
  }
}
