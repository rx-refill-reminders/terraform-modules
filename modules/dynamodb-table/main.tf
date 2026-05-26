resource "aws_dynamodb_table" "table" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"

  hash_key  = var.hash_key
  range_key = var.range_key

  ttl {
    enabled        = var.ttl_attribute != null
    attribute_name = var.ttl_attribute
  }

  dynamic "attribute" {
    for_each = var.attributes

    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  dynamic "global_secondary_index" {
    for_each = var.global_secondary_index_map

    content {
      name = global_secondary_index.value.name

      hash_key  = global_secondary_index.value.hash_key
      range_key = lookup(global_secondary_index.value, "range_key", null)

      non_key_attributes = lookup(global_secondary_index.value, "non_key_attributes", null)
      projection_type    = global_secondary_index.value.projection_type
    }
  }

  timeouts {
    create = var.create_timeout
    update = var.update_timeout
  }
}

resource "aws_dynamodb_resource_policy" "access_policy" {
  count = length(var.editors) > 0 ? 1 : 0

  resource_arn = aws_dynamodb_table.table.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = var.editors
        }
        Action = [
          "dynamodb:BatchGetItem",
          "dynamodb:BatchWriteItem",
          "dynamodb:DeleteItem",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:UpdateItem",
        ]
        Resource = aws_dynamodb_table.table.arn
      }
    ]
  })
}
