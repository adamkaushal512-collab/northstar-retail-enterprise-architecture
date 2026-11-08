output "table_arns" {
  value = [for t in aws_dynamodb_table.tables : t.arn]
}
output "table_names" {
  value = { for k, t in aws_dynamodb_table.tables : k => t.name }
}
