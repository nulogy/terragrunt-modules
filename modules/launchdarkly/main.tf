locals {
  nulogy_blue   = "00397A"
  nulogy_yellow = "FFBB00"
}

resource "launchdarkly_environment" "environment" {
  count = var.use_shared_environment ? 0 : 1

  project_key = var.project_key
  key         = var.environment_key
  name        = var.environment_name
  color       = var.production_environment ? local.nulogy_blue : local.nulogy_yellow
  tags        = var.environment_tags
}

data "launchdarkly_environment" "shared_environment" {
  count = var.use_shared_environment ? 1 : 0

  project_key = var.project_key
  key         = var.environment_key
}
