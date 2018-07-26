# Use data resources to ensure that required SSM params exist; Set these manually

data "aws_ssm_parameter" "rabbitmq_ssl_cert" {
    name = "/${var.environment_name}/rabbitmq/ssl-cert-base64"
}

data "aws_ssm_parameter" "rabbitmq_ssl_cacert" {
    name = "/${var.environment_name}/rabbitmq/ssl-cacert-base64"
}

data "aws_ssm_parameter" "rabbitmq_ssl_key" {
    name = "/${var.environment_name}/rabbitmq/ssl-key-base64"
}
