module "notification_system" {
  source = "../../modules/notification_system"
  topic_name = "${var.environment_name}"
}
