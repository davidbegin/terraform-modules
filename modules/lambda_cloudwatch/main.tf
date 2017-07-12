resource "aws_cloudwatch_log_group" "cloud_watch_log_group" {
  name = "/aws/lambda/${var.function_name}"
}

resource "aws_lambda_function" "lambda_function" {
  function_name = "${var.function_name}"
  handler       = "${var.handler}"
  runtime       = "${var.runtime}"
  role          = "${aws_iam_role.lambda_exec_role.arn}"

  # These should be set by the user of the module
  filename         = "function.zip"
  source_code_hash = "${base64sha256(file("function.zip"))}"

  # Or if you want s3
  # s3_bucket = "insert_s3_bucket"
  # s3_key    = "insety_s3_key"
}

resource "aws_iam_role" "lambda_exec_role" {
  name        = "lambda_exec_role"
  description = "Allows Lambda Function to call AWS services on your behalf."
  path        = "/"

  assume_role_policy = <<EOF
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

resource "aws_iam_policy_attachment" "AWSLambdaBasicExecutionRole-policy-attachment" {
  name       = "AWSLambdaBasicExecutionRole-policy-attachment"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  groups     = []
  users      = []
  roles      = ["${aws_iam_role.lambda_exec_role.name}"]
}
