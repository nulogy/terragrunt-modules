output "dashboard_url" {
  value = "https://app.datadoghq.com${datadog_dashboard.dashboard.url}"
}

