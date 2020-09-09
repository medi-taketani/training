resource "aws_apigatewayv2_api" "this" {
  name          = var.apigw_name
  protocol_type = "HTTP"
  target        = var.target_lambda_arn
}

resource "aws_apigatewayv2_integration" "this" {
  api_id           = aws_apigatewayv2_api.this.id
  integration_type = "AWS_PROXY"

  connection_type           = "INTERNET"
  description               = var.description
  integration_method        = "POST"
  integration_uri           = var.target_lambda_integration_uri
  passthrough_behavior      = "WHEN_NO_MATCH"
}

resource "aws_apigatewayv2_route" "this" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = var.route_key
  target    = "integrations/${aws_apigatewayv2_integration.this.id}"
}