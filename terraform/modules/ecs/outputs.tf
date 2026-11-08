output "ecs_cluster_id" {
  description = "ID of the ECS cluster"
  value       = aws_ecs_cluster.main.id
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.main.name
}

output "ecs_service_name" {
  description = "Name of the Reservation Service"
  value       = aws_ecs_service.reservation_service.name
}

output "ecs_service_id" {
  description = "ID of the Reservation Service"
  value       = aws_ecs_service.reservation_service.id
}

output "task_definition_arn" {
  description = "ARN of the Reservation Service task definition"
  value       = aws_ecs_task_definition.reservation_service.arn
}

output "internal_alb_arn" {
  description = "ARN of the internal Application Load Balancer"
  value       = aws_lb.internal.arn
}

output "internal_alb_dns_name" {
  description = "Private-facing DNS name of the internal ALB"
  value       = aws_lb.internal.dns_name
}

output "reservation_target_group_arn" {
  description = "ARN of the Reservation Service target group"
  value       = aws_lb_target_group.reservation_service.arn
}

output "cloudwatch_log_group_name" {
  description = "CloudWatch log group for the Reservation Service"
  value       = aws_cloudwatch_log_group.reservation_service.name
}

output "autoscaling_target_resource_id" {
  description = "Application Auto Scaling resource ID"
  value       = aws_appautoscaling_target.reservation_service.resource_id
}
