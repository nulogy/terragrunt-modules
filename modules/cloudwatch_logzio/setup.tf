provider "aws" {
  version = "2.70.0"
  region  = var.aws_region
  profile = var.aws_profile
}

provider "archive" {
  version = "1.2.2"
}

# This token is manually added into AWS accounts that have environments that require the Logz.io module
data "aws_ssm_parameter" "logzio__api_key" {
  name = "/logzio/api-key"
}

