data "archive_file" "lambda_zip" {
  output_path = "logzio-cloudwatch.zip"
  source_dir  = "${path.module}/src"
  type        = "zip"
}

resource "aws_lambda_function" "lambda" {
  description      = "AWS Lambda Function that ingests CloudWatch logs into Logz.io. Environment: ${var.environment_name}. Terraform Module: ${var.logzio__module_name}."
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "${var.environment_short_name}-${var.logzio__module_name}-ship-logzio"
  handler          = "lambda_function.lambda_handler"
  memory_size      = "512"
  role             = aws_iam_role.lambda_role.arn
  runtime          = "python3.7"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  timeout          = "60"

  environment {
    variables = {
      FORMAT = var.logzio__logs_format
      REGION = "us"
      TOKEN  = var.logzio__api_key
      TYPE   = var.logzio__logs_type
    }
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

