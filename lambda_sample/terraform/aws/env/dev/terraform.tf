// terraform
terraform {
  required_version = ">= 0.13"

  backend "s3" {
    bucket = "taketani-terraform"
    key    = "aws/lambda_sample/tfstate.tf"
    region = "ap-northeast-1"
  }
}

