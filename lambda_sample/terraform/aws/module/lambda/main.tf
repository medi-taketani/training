data "archive_file" "lambda_zip" {
  type = "zip"
  source_file = var.source_file
  output_path = var.output_path
}

resource "aws_lambda_function" "this" {
  filename      = data.archive_file.lambda_zip.output_path
  function_name = var.func_name
  role          = aws_iam_role.this.arn
  handler       = "lambda_function.lambda_handler"

  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  runtime = "python3.8"

  environment {
    variables = {
      TEST_VAR                = var.environment.TEST_VAR
    }
  }
}

resource "aws_lambda_permission" "apigw" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn    = "${var.lambda_trigger_source_execution_arn}/*/*"
}


resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${var.func_name}"
  retention_in_days = 14
}

resource "aws_iam_role" "this" {
  name = "taketani_test_lambda_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "this" {
  name        = "lambda_logging_into_cloudwatch"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}

data "aws_iam_policy" "AmazonSSMReadOnlyAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.this.name
  policy_arn = data.aws_iam_policy.AmazonSSMReadOnlyAccess.arn
}