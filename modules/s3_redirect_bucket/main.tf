resource "aws_s3_bucket" "redirect_bucket" {
  bucket_prefix = "${var.environment_name}-redirect-"

  tags = {
    resource_group = var.environment_name
  }

  website {
    redirect_all_requests_to = var.destination_domain_name
  }
}
