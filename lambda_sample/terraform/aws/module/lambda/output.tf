output "lambda_func_arn" {
    value = aws_lambda_function.this.arn
}

output "lambda_integration_uri" {
    value = aws_lambda_function.this.invoke_arn
}