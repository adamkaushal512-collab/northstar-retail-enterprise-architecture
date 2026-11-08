variable "environment" {
  description = "Deployment environment (dev, staging, or prod)"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "vpc_id" {
  description = "VPC ID provided by the networking module"
  type        = string
}

variable "application_port" {
  description = "Application port used by the ECS service"
  type        = number
  default     = 8080

  validation {
    condition     = var.application_port >= 1 && var.application_port <= 65535
    error_message = "Application port must be between 1 and 65535."
  }
}

variable "dynamodb_table_arns" {
  description = "DynamoDB table ARNs the Reservation Service is authorized to access"
  type        = list(string)

  validation {
    condition     = length(var.dynamodb_table_arns) > 0 && alltrue([for arn in var.dynamodb_table_arns : can(regex("^arn:[^:]+:dynamodb:[^:]+:[0-9]{12}:table/[^/]+$", arn))])
    error_message = "Provide at least one valid DynamoDB table ARN."
  }
}

variable "alb_certificate_arn" {
  description = "ARN of the ACM certificate for the internal ALB HTTPS listener"
  type        = string

  validation {
    condition = can(regex(
      "^arn:[^:]+:acm:[^:]+:[0-9]{12}:certificate/[0-9a-fA-F-]+$",
      var.alb_certificate_arn
    ))
    error_message = "Provide a valid AWS ACM certificate ARN."
  }
}
