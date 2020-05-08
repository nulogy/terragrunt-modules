module "ecr" {
  source = "../../modules//ecr"

  name                 = "event-shovel-${var.environment_name}"
  count_cap_tag_prefix = "event-shovel-${var.environment_name}"
}

