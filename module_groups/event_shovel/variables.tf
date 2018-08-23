variable "aws_region" {
  description = "The AWS Region you want to send everything to. Pick something close to the customer."
  default = "us-east-1"
}

variable "environment_name" {
  description = "Environment name. Used for tagging."
}

variable "alert_endpoint" {
  description = "A POST endpoint to send alerts to. Put Pagerduty here. Leave blank for nowhere."
  default = ""
}

variable "amqp_host" {
  description = "The RabbitMQ host. Cluster lives in the CPI Project."
}

variable "amqp_user" {
  description = "The RabbitMQ username for connections."
}

variable "amqp_exchange_name" {
  description = "The RabbitMQ queue name."
}

variable "docker_build_tag" {
  description = "Docker Tag to use."
}

variable "ecs_cluster_name" {
  description = "The name of the ECS cluster to run event shovel inside. (i.e. the `ecs_cluster_name` output of the `ecs_cluster` module)"
}

variable "notification_topic_arn" {
  description = "The topic ARN to send alert notifications to. (i.e. the `topic_arn` output of the `notification_system` module)"
}

variable "kms_key_id" {
  description = "The KMS key id used for decrypting event shovel secrets stored in param store"
}

# All of these need to be set manually for now. Once packmanager goes 100% RDS or we've upgraded to terraform 0.12, we can improve this.
variable "overridden_db_hostname" {
  description = "Set this to a non-empty string to force event shovel to connect to a configured database host instead of discovering the database address from remote state"
  # default = ""
}

variable "overridden_db_user" {
  description = "Set this to a non-empty string to force event shovel to connect to the database with this username instead of discovering it from remote state"
  # default = ""
}

variable "overridden_db_name" {
  description = "Set this to a non-empty string to force event shovel to connect to this database name instead of discovering the database address from remote state"
  # default = ""
}
