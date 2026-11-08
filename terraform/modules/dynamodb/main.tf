locals { tables = toset(["inventory", "reservations", "outbox"]) }
resource "aws_dynamodb_table" "tables" {
  for_each     = local.tables
  name         = "northstar-${var.environment}-${each.key}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "pk"
  range_key    = "sk"
  attribute {
    name = "pk"
    type = "S"
  }
  attribute {
    name = "sk"
    type = "S"
  }
  point_in_time_recovery {
    enabled = var.point_in_time_recovery
  }
  server_side_encryption {
    enabled = true
  }
  tags = { Environment = var.environment, Project = "NorthStarRetail", ManagedBy = "Terraform" }
}
