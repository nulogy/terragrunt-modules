resource "aws_kms_key" "kms_key" {
  enable_key_rotation = true

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_kms_alias" "kms_alias" {
  name          = "alias/${var.environment_name}"
  target_key_id = aws_kms_key.kms_key.key_id
}

