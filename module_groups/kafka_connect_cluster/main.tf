locals {
  normalized_connector_name = replace(var.kafka_connect__connector_name, "_", "-")

  // Connect ENVARS reference: https://hub.docker.com/r/debezium/connect-base
  envars = jsonencode([
    {
      name  = "BOOTSTRAP_SERVERS",
      value = var.kafka_connect__bootstrap_servers
    },
    // required
    // Kafka topic where the Kafka Connect services in the group store connector configurations
    // The topic must have a single partition, should be highly replicated (e.g., 3x or more) and should be configured for compaction
    {
      name  = "CONFIG_STORAGE_TOPIC",
      value = "kconnect-config-${local.normalized_connector_name}"
    },
    {
      name  = "CONNECT_CONFIG_STORAGE_REPLICATION_FACTOR",
      value = "3"
    },
    // required
    // Kafka topic where the Kafka Connect services in the group store connector offsets
    // The topic should have many partitions, be highly replicated (e.g., 3x or more) and should be configured for compaction
    {
      name  = "OFFSET_STORAGE_TOPIC",
      value = "kconnect-offset-${local.normalized_connector_name}"
    },
    {
      name  = "CONNECT_OFFSET_STORAGE_REPLICATION_FACTOR",
      value = "3"
    },
    // should be provided
    // Kafka topic where the Kafka Connect services in the group store connector status
    // The topic can have multiple partitions, should be highly replicated (e.g., 3x or more) and should be configured for compaction
    {
      name  = "STATUS_STORAGE_TOPIC",
      value = "kconnect-status-${local.normalized_connector_name}"
    },
    {
      name  = "CONNECT_STATUS_STORAGE_REPLICATION_FACTOR",
      value = "3"
    },
    // Uniquely identifies a Kafka connect cluster
    {
      name  = "GROUP_ID",
      value = local.normalized_connector_name
    },
    {
      name  = "ENVIRONMENT",
      value = local.normalized_connector_name
    }
  ])
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
  docker_image_name         = "nulogy/debezium-connect:1.6.2.Final"
  ecs_cluster_name          = var.ecs_cluster_name
  ecs_service_name          = local.normalized_connector_name
  ecs_incoming_allowed_cidr = module.vpc.vpc_cidr
  envars                    = local.envars
  environment_name          = local.normalized_connector_name
  health_check_path         = "/connectors"
  internal                  = true
  kms_key_id                = var.kms_key_id
  lb_ip_address_type        = "ipv4"
  lb_security_group_ids     = [aws_security_group.lb_security_group.id]
  memory                    = var.kafka_connect__ecs_memory
  param_store_namespace     = local.normalized_connector_name
  private_subnets           = module.vpc.private_subnet_ids
  public_subnets            = module.vpc.public_subnet_ids
  security_group_name       = "${local.normalized_connector_name}-kafka-connect-sg"
  service_name              = "${local.normalized_connector_name}-kafka-connect"
  slow_start                = 30
  vpc_cidr                  = module.vpc.vpc_cidr
  vpc_id                    = module.vpc.vpc_id
}
