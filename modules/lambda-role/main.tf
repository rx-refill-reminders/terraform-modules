data "aws_caller_identity" "current" {}

resource "aws_iam_role" "role" {
  name = "${var.role_name_prefix}-${data.aws_caller_identity.current.account_id}"

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

resource "aws_iam_role_policy" "policy" {
  name = "${var.role_name_prefix}-policy-${data.aws_caller_identity.current.account_id}"
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

  dynamic "statement" {
    for_each = var.user_files_bucket_arn != null ? [1] : []

    content {
      sid = "AllowUserFilesS3"

      actions = [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject",
      ]

      effect    = "Allow"
      resources = ["${var.user_files_bucket_arn}/*"]
    }
  }
}
