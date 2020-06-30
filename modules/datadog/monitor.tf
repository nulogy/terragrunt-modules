resource "datadog_monitor" "app_worker_apdex" {
  name    = "Service ${var.environment_name}/app_worker has an abnormal change in Apdex"
  type    = "metric alert"

  thresholds = {
    "critical" = "0.75"
  }
  require_full_window = false

  message = <<-EOF
Apdex deviated too much from its usual value.

Check service dashboard for more information:

https://app.datadoghq.com${datadog_dashboard.dashboard.url}

@${var.environment_name}/app_worker

%{ if length(var.pagerduty_service) > 0 }
@pagerduty-${replace(var.pagerduty_service, " ", "")}
%{ endif }
EOF

  query = "avg(last_5m):avg:trace.rack.request.apdex.by.service{env:${var.dd_env},service:${var.environment_name}/app_worker} < 0.75"

  tags = [
    "service:${var.environment_name}/app_worker",
    "env:${var.dd_env}"
  ]
}

