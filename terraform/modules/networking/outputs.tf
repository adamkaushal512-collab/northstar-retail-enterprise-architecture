output "vpc_id" {
  description = "NorthStar Retail VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs across two Availability Zones"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "Private subnet IDs for ECS workloads"
  value       = aws_subnet.private[*].id
}

output "nat_gateway_ids" {
  description = "NAT Gateway IDs"
  value       = aws_nat_gateway.main[*].id
}

output "dynamodb_endpoint_id" {
  description = "DynamoDB Gateway VPC Endpoint ID"
  value       = aws_vpc_endpoint.dynamodb.id
}

output "s3_endpoint_id" {
  description = "S3 Gateway VPC Endpoint ID"
  value       = aws_vpc_endpoint.s3.id
}

output "interface_endpoint_ids" {
  description = "Optional ECR and CloudWatch interface endpoint IDs"
  value       = { for name, endpoint in aws_vpc_endpoint.interfaces : name => endpoint.id }
}
