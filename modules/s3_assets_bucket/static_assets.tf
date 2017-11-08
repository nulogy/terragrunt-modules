locals {
  static_assets_bucket_name = "${var.environment_name}-static-assets"
}

resource "aws_s3_bucket" "static_assets" {
  count = "${length(var.skip) > 0 ? 0 : 1}"

  bucket = "${local.static_assets_bucket_name}"
  acl = "public-read"
  policy = "${data.aws_iam_policy_document.s3_static_assets_policy.json}"
  force_destroy = true

  tags {
    Name = "${var.environment_name} static assets"
    resource_group = "${var.environment_name}"
  }
}

data "aws_iam_policy_document" "s3_static_assets_policy" {
  count = "${length(var.skip) > 0 ? 0 : 1}"

  statement {
    actions = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${local.static_assets_bucket_name}/*"]
    principals {
      type = "AWS"
      identifiers = ["*"]
    }
  }
}
