output "event_bus_name" {
  value = aws_cloudwatch_event_bus.retail.name
}
output "event_bus_arn" {
  value = aws_cloudwatch_event_bus.retail.arn
}
output "consumer_queue_urls" {
  value = { for k, q in aws_sqs_queue.consumer : k => q.id }
}
output "consumer_dlq_urls" {
  value = { for k, q in aws_sqs_queue.dlq : k => q.id }
}
