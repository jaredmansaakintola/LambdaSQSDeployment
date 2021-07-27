<<<<<<< HEAD

#SQS resource:

resource "aws_sqs_queue" "sync_queue" {
  name                      = "sync_queue"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  #redrive_policy = jsonencode({
  #  deadLetterTargetArn = aws_sqs_queue.terraform_queue_deadletter.arn
  #  maxReceiveCount     = 4
  #})
}

#Lambda resource and role to connect to AWS config user

variable "lambda_function_name" {
  default = "lambda_handler"
=======
variable "lambda_function_name" {
  default = "lambda_function_name"
>>>>>>> a9d9e8450487d74576b768da7b049711fc54133f
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

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

<<<<<<< HEAD
data "archive_file" "zipit" {
  type        = "zip"
  source_file = "lambda_handler.py"
  output_path = "lambda_handler.zip"
}

resource "aws_lambda_function" "sync_lambda" {
  filename         = "lambda_handler.zip"
  function_name    = var.lambda_function_name
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "exports.test"
  #source_code_hash = "${base64sha256(file("lambda_handler.zip"))}"
  source_code_hash = data.archive_file.zipit.output_base64sha256
  runtime          = "python3.7"
=======
resource "aws_lambda_function" "test_lambda" {
  filename         = "lambda_function_payload.zip"
  function_name    = var.lambda_function_name
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  handler          = "exports.test"
  source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  runtime          = "nodejs4.3"
>>>>>>> a9d9e8450487d74576b768da7b049711fc54133f

  environment {
    variables = {
      foo = "bar"
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs,
    aws_iam_role_policy_attachment.lambda_sqs,
    #aws_cloudwatch_log_group.example,
  ]
}

<<<<<<< HEAD
# Logging resource (Cloud Watch)
=======
>>>>>>> a9d9e8450487d74576b768da7b049711fc54133f
resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
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

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

<<<<<<< HEAD
# Sqs to lambda connection and permissions

resource "aws_sqs_queue_policy" "sync_queue_policy" {
  queue_url   = aws_sqs_queue.sync_queue.id
=======
resource "aws_iam_policy" "lambda_sqs" {
  name        = "lambda_sqs"
  path        = "/"
  description = "IAM policy for sqs connection from a lambda"
>>>>>>> a9d9e8450487d74576b768da7b049711fc54133f

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes",
        "sqs:ReceiveMessage"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_sqs" {
  role       = aws_iam_role.iam_for_lambda.name
<<<<<<< HEAD
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"
}

# Event source from SQS
resource "aws_lambda_event_source_mapping" "event_source_mapping" {
  event_source_arn = aws_sqs_queue.sync_queue.arn
  enabled          = true
  function_name    = aws_lambda_function.sync_lambda.arn
  batch_size       = 1
=======
  policy_arn = aws_iam_policy.lambda_sqs.arn
>>>>>>> a9d9e8450487d74576b768da7b049711fc54133f
}
