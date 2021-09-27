provider "aws" {
  # This has to be us-east-1, cloudfront requires the certificate in that region, regardless of where the environment is
  # https://docs.aws.amazon.com/acm/latest/userguide/acm-regions.html
  region  = var.aws_region
  profile = var.aws_profile
}

terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {
  }
}