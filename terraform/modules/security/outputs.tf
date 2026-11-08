output "alb_security_group_id" {
  description = "Security group ID for the internal Application Load Balancer"
  value       = aws_security_group.alb.id
}

output "ecs_security_group_id" {
  description = "Security group ID for the ECS Reservation Service"
  value       = aws_security_group.ecs.id
}

output "ecs_execution_role_arn" {
  description = "IAM role ARN used by ECS to pull images and write logs"
  value       = aws_iam_role.ecs_execution.arn
}

output "ecs_task_role_arn" {
  description = "IAM role ARN used by the Reservation Service application"
  value       = aws_iam_role.ecs_task.arn
}

output "alb_certificate_arn" {
  description = "ACM certificate ARN for the internal ALB HTTPS listener"
  value       = var.alb_certificate_arn
}
