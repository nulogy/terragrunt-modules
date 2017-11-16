module "notification_system" {
  source = "../../modules/notification_system"
  topic_name = "${var.environment_name}"
}

module "kms_master_key" {
  source = "../../modules/kms_master_key"
  environment_name = "${var.environment_name}"
}
