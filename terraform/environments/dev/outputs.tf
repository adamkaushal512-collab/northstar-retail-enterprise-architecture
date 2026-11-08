output "vpc_id" {
  value = module.networking.vpc_id
}
output "ecs_cluster" {
  value = module.ecs.ecs_cluster_name
}
output "internal_alb_dns" {
  value = module.ecs.internal_alb_dns_name
}
output "dynamodb_tables" {
  value = module.dynamodb.table_names
}
output "event_bus" {
  value = module.eventbridge.event_bus_name
}
