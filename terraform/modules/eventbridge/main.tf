data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
locals { consumers = toset(["inventory-view", "store-fulfillment", "analytics"]) }
resource "aws_cloudwatch_event_bus" "retail" {
  name = "northstar-${var.environment}-retail"
  tags = { Environment = var.environment, Project = "NorthStarRetail" }
}
resource "aws_sqs_queue" "dlq" {
  for_each                  = local.consumers
  name                      = "northstar-${var.environment}-${each.key}-dlq"
  message_retention_seconds = 1209600
  sqs_managed_sse_enabled   = true
}
resource "aws_sqs_queue" "consumer" {
  for_each                   = local.consumers
  name                       = "northstar-${var.environment}-${each.key}"
  visibility_timeout_seconds = 60
  message_retention_seconds  = 345600
  sqs_managed_sse_enabled    = true
  redrive_policy             = jsonencode({ deadLetterTargetArn = aws_sqs_queue.dlq[each.key].arn, maxReceiveCount = 5 })
}
resource "aws_sqs_queue_redrive_allow_policy" "dlq" {
  for_each             = local.consumers
  queue_url            = aws_sqs_queue.dlq[each.key].id
  redrive_allow_policy = jsonencode({ redrivePermission = "byQueue", sourceQueueArns = [aws_sqs_queue.consumer[each.key].arn] })
}
resource "aws_cloudwatch_event_rule" "inventory" {
  name           = "northstar-${var.environment}-inventory-events"
  event_bus_name = aws_cloudwatch_event_bus.retail.name
  event_pattern  = jsonencode({ source = ["northstar.reservations"], "detail-type" = ["InventoryReserved", "InventoryReleased"] })
}
resource "aws_cloudwatch_event_target" "consumer" {
  for_each       = local.consumers
  rule           = aws_cloudwatch_event_rule.inventory.name
  event_bus_name = aws_cloudwatch_event_bus.retail.name
  arn            = aws_sqs_queue.consumer[each.key].arn
  target_id      = replace(each.key, "-", "_")
}
data "aws_iam_policy_document" "allow_eventbridge" {
  for_each = local.consumers
  statement {
    effect    = "Allow"
    actions   = ["sqs:SendMessage"]
    resources = [aws_sqs_queue.consumer[each.key].arn]
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [aws_cloudwatch_event_rule.inventory.arn]
    }
  }
}
resource "aws_sqs_queue_policy" "allow_eventbridge" {
  for_each  = local.consumers
  queue_url = aws_sqs_queue.consumer[each.key].id
  policy    = data.aws_iam_policy_document.allow_eventbridge[each.key].json
}
