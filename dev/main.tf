
provider "aws" {
  region = "us-east-1"
}

module "lambda_demo" {
  source = "../modules/lambda_cloudwatch"

  function_name = "demo_for_figuring_out_cloudwatch"
  handler       = "index.handler"
  runtime       = "nodejs4.3"
}
