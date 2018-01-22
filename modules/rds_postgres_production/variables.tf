variable "environment_name" {}
variable "subnet_ids" { type = "list" }
variable "vpc_cidr" {}
variable "vpc_id" {}

variable "db_allocated_storage" {}
# apply changes immediatelly with terraform
variable "db_apply_immediatelly" { default = true }
variable "db_auto_major_version_upgrade" { default = false }
variable "db_auto_minor_version_upgrade" { default = true }
variable "db_backup_retention_period" { default = 7 }
# 06:00 UTC = 01:00 EDT or 02:00 EST
# ref: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_WorkingWithAutomatedBackups.html
variable "db_backup_window" { default = "06:00-07:00" }
# latest version
# ref: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_PostgreSQL.html#PostgreSQL.Concepts.General.DBVersions
variable "db_engine_version" { default = "9.4.14" }
variable "db_iam_database_authentication_enabled" { default = false }
# Current Generation Burstable Performance Instance Classes
# ref: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.DBInstanceClass.html
variable "db_instance_class" { default = "db.t2.micro" }
variable "db_iops" { default = 0 }
variable "db_kms_key_id" { default = "" }
# 08:00 UTC = 03:00 EDT or 04:00 EST
variable "db_maintenance_window" { default = "sun:08:00-sun:09:00" }
variable "db_monitoring_interval" { default = 15 }
variable "db_name" { default = "" }
variable "db_parameter_group_name" { default = "default.postgres9.4" }
variable "db_password" {}
variable "db_port" { default = 5432 }
variable "db_replicate_source_db" { default = "" }
variable "db_snapshot_identifier" { default = "" }
variable "db_storage_type" { default = "gp2" }
variable "db_username" {}
