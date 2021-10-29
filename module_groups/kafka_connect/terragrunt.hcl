# THIS FILE IS BOILERPLATE.  DO NOT MODIFY

include {
  path = fileexists("./dependencies.hcl") ? "./dependencies.hcl" : "/deployer/utils/empty.hcl"
}

locals {
  aws_profile           = basename(dirname("${local.environment_dir}/../../"))
  aws_region            = local.env_file_decoded["aws_region"]
  env_file_decoded      = yamldecode(file(local.environment_file_path))
  environment_dir       = abspath("${get_terragrunt_dir()}/../../../")
  environment_file_path = "${local.environment_dir}/environment.yml"
  environment_name      = basename(local.environment_dir)
  module_name           = basename(get_terragrunt_dir())
}

remote_state {
  backend = "s3"
  config = {
    bucket                 = "${local.aws_profile}-${local.aws_region}-terraform-state"
    key                    = "${local.environment_name}/${local.module_name}/terraform.tfstate"
    profile                = local.aws_profile
    region                 = local.aws_region
    encrypt                = true
    skip_bucket_versioning = false
    dynamodb_table         = "terragrunt-lock-table"
  }
}

terraform {
  source = "."
}

inputs = merge(local.env_file_decoded, {
  aws_profile      = local.aws_profile
  environment_dir  = local.environment_dir
  environment_name = local.environment_name
})
