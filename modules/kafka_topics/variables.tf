variable "bootstrap_servers" {
  description = "Kafka's bootstrap server(s) to connect to"
}

variable "topics" {
  description = "The names of topics to create"
  default     = []
  type        = set(string)
}

variable "replication_factor" {
  description = "The replication factor for the topic (how many brokers to replicate the topic to)"
  default     = 3
}

variable "partitions" {
  description = "How many partitions to create for the topic (allows greater parallelization and throughput)"
  default     = 10
}

variable "retention" {
  description = "Maximum time to keep a log before it could be deleted in MILLISECONDS"
  default     = 604800000 # 1 week
}
