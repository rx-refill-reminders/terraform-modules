data "aws_caller_identity" "current" {}

# IAM role Lambda assumes at runtime to access AWS services on behalf of the function.
resource "aws_iam_role" "role" {
  name = "${var.role_name}"

  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# Inline policy granting CloudWatch Logs, Secrets Manager, SSM, Step Functions, DynamoDB, and optional user-files S3 access.
resource "aws_iam_role_policy" "policy" {
  name = "${var.role_name}-policy"
  role = aws_iam_role.role.id

  policy = data.aws_iam_policy_document.lambda_policy.json
}

data "aws_iam_policy_document" "lambda_policy" {
  statement {
    sid = "WriteLogs"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    effect    = "Allow"
    resources = ["*"]
  }

  statement {
    sid = "ReadSecrets"

    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
    ]

    effect    = "Allow"
    resources = ["*"]
  }

  statement {
    sid = "AllowSSM"

    actions = [
      "ssm:GetParameter",
      "ssm:PutParameter",
    ]

    effect    = "Allow"
    resources = ["*"]
  }

  statement {
    sid = "AllowStepFunctions"

    actions = [
      "states:StartExecution",
    ]

    effect    = "Allow"
    resources = ["*"]
  }

  statement {
    sid = "AllowDDB"

    actions = [
      "dynamodb:BatchGetItem",
      "dynamodb:BatchWriteItem",
      "dynamodb:DeleteItem",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:Scan",
      "dynamodb:Query",
    ]

    effect    = "Allow"
    resources = ["*"]
  }
}
