data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir = "${path.module}/src"
  output_path = "lambda.zip"
}

resource "aws_lambda_function" "lambda" {
  filename         = "lambda.zip"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  function_name    = "${var.environment_short_name}-${var.logzio__module_name}-ship-logzio"
  role             = aws_iam_role.lambda_role.arn
  description      = "AWS Lambda Function that ingests CloudWatch logs into Logz.io. Environment: ${var.environment_name}. Terraform Module: ${var.logzio__module_name}."
  handler          = "lambda.lambda_handler"
  runtime          = "python2.7"
  timeout          = "30"

  environment {
    variables = {
      FORMAT = var.logzio__logs_format
      TOKEN  = data.aws_ssm_parameter.logzio__api_key.value
      TYPE   = var.logzio__logs_type
      URL    = var.logzio__api_url
    }
  }

  lifecycle {
    ignore_changes = [environment]
  }
}

resource "aws_cloudwatch_log_subscription_filter" "logfilter" {
  name            = "logzio_logfilter"
  log_group_name  = var.logzio__log_group_name
  filter_pattern  = ""
  destination_arn = aws_lambda_function.lambda.arn
  distribution    = "ByLogStream"
}

resource "aws_iam_role" "lambda_role" {
  name               = "${var.environment_short_name}-${var.logzio__module_name}-cloudwatch-to-logzio"
  assume_role_policy = <<-EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
            "Service": "lambda.amazonaws.com"
          },
          "Action": "sts:AssumeRole"
        }
      ]
    }
  EOF
}

resource "aws_lambda_permission" "allows_cloudwatch_execute_lambda" {
  statement_id  = "${var.environment_short_name}-${var.logzio__module_name}-allows-cloudwatch-execute-lambda"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.arn
  principal     = "logs.${var.aws_region}.amazonaws.com"
  source_arn    = var.logzio__log_group_arn
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "${var.environment_short_name}-${var.logzio__module_name}-cloudwatch-to-logzio"
  description = "Allows Lambda to write its execution logs into CloudWatch."
  policy      = <<-EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Action": [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Resource": "arn:aws:logs:*:*:*"
        }
      ]
    }
  EOF
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  policy_arn = aws_iam_policy.lambda_policy.arn
  role       = aws_iam_role.lambda_role.name
}

