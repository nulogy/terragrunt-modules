output "topic_arn" {
  value = "${module.notification_system.topic_arn}"
}

output "kms_key_id" {
  value = "${module.kms_master_key.kms_key_id}"
}
