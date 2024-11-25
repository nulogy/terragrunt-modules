locals {
  normalized_cluster_name = replace(var.kafka_connect__cluster_name, "_", "-")

  // Connect ENVARS reference: https://hub.docker.com/r/debezium/connect-base
  default_envars = [
    // required
    // List of Kafka brokers.
    {
      name  = "BOOTSTRAP_SERVERS",
      value = var.kafka_connect__bootstrap_brokers
    },
    // required
    // Kafka topic where the Kafka Connect services in the group store connector configurations
    // The topic must have a single partition, should be highly replicated (e.g., 3x or more) and should be configured for compaction
    {
      name  = "CONFIG_STORAGE_TOPIC",
      value = "kconnect-config-${local.normalized_cluster_name}"
    },
    {
      name  = "CONNECT_CONFIG_STORAGE_REPLICATION_FACTOR",
      value = tostring(var.kafka_connect__config_storage_replication_factor)
    },
    // required
    // Kafka topic where the Kafka Connect services in the group store connector offsets
    // The topic should have many partitions, be highly replicated (e.g., 3x or more) and should be configured for compaction
    {
      name  = "OFFSET_STORAGE_TOPIC",
      value = "kconnect-offset-${local.normalized_cluster_name}"
    },
    {
      name  = "CONNECT_OFFSET_STORAGE_REPLICATION_FACTOR",
      value = tostring(var.kafka_connect__offset_replication_factor)
    },
    // should be provided
    // Kafka topic where the Kafka Connect services in the group store connector status
    // The topic can have multiple partitions, should be highly replicated (e.g., 3x or more) and should be configured for compaction
    {
      name  = "STATUS_STORAGE_TOPIC",
      value = "kconnect-status-${local.normalized_cluster_name}"
    },
    {
      name  = "CONNECT_STATUS_STORAGE_REPLICATION_FACTOR",
      value = tostring(var.kafka_connect__status_storage_replication_factor)
    },
    // Uniquely identifies a Kafka connect cluster
    {
      name  = "GROUP_ID",
      value = local.normalized_cluster_name
    },
    {
      name  = "ENVIRONMENT",
      value = local.normalized_cluster_name
    },
    // Use TLS for communication with Kafka
    {
      name  = "CONNECT_SECURITY_PROTOCOL",
      value = "SSL"
    },
    {
      name  = "CONNECT_CONSUMER_SECURITY_PROTOCOL",
      value = "SSL"
    },
    {
      name  = "CONNECT_PRODUCER_SECURITY_PROTOCOL",
      value = "SSL"
    },
  ]

  kafka_connect_envars = jsonencode(
    concat(local.default_envars, var.additional_envars)
  )
}

module "vpc" {
  source = "../../modules/data_shared_vpc"
  type   = var.shared_vpc__type
}

module "kafka_connect" {
  source = "../ecs_fargate_with_elb"

  cert_domain               = var.cert_domain
  command                   = ["start"]
  container_port            = "8083"
  cpu                       = var.kafka_connect__ecs_cpu
  desired_count             = var.kafka_connect__task_count
  docker_image_name         = var.kafka_connect__docker_image_name
  ecs_cluster_name          = var.ecs_cluster_name
  ecs_service_name          = local.normalized_cluster_name
  ecs_incoming_allowed_cidr = module.vpc.vpc_cidr
  envars                    = local.kafka_connect_envars
  environment_name          = local.normalized_cluster_name
  health_check_path         = "/connectors"
  internal                  = true
  kms_key_id                = var.kms_key_id
  lb_ip_address_type        = "ipv4"
  lb_security_group_ids     = [aws_security_group.lb_security_group.id]
  memory                    = var.kafka_connect__ecs_memory
  param_store_namespace     = local.normalized_cluster_name
  private_subnets           = module.vpc.private_subnet_ids
  public_subnets            = module.vpc.public_subnet_ids
  security_group_name       = "${local.normalized_cluster_name}-kafka-connect-sg"
  service_name              = "${local.normalized_cluster_name}-kafka-connect"
  slow_start                = 30
  vpc_cidr                  = module.vpc.vpc_cidr
  vpc_id                    = module.vpc.vpc_id
}
