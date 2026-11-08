variable "environment" {
  description = "Deployment environment"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "vpc_id" {
  description = "VPC ID from the networking module"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for the internal ALB and ECS tasks"
  type        = list(string)

  validation {
    condition     = length(var.private_subnet_ids) >= 2
    error_message = "At least two private subnets are required."
  }
}

variable "alb_security_group_id" {
  description = "ALB security group ID"
  type        = string
}

variable "ecs_security_group_id" {
  description = "ECS security group ID"
  type        = string
}

variable "ecs_execution_role_arn" {
  description = "ECS task execution IAM role ARN"
  type        = string
}

variable "ecs_task_role_arn" {
  description = "ECS application task IAM role ARN"
  type        = string
}

variable "certificate_arn" {
  description = "ACM certificate ARN for the HTTPS listener"
  type        = string
}

variable "container_image" {
  description = "Container image URI for the Reservation Service"
  type        = string
}

variable "application_port" {
  description = "Application container port"
  type        = number
  default     = 8080
}

variable "desired_count" {
  description = "Number of ECS tasks"
  type        = number
  default     = 2

  validation {
    condition     = var.desired_count >= 1
    error_message = "Desired task count must be at least 1."
  }
}

variable "min_capacity" {
  description = "Minimum number of ECS tasks maintained by auto scaling"
  type        = number
  default     = 2

  validation {
    condition     = var.min_capacity >= 1
    error_message = "Minimum capacity must be at least 1."
  }
}

variable "max_capacity" {
  description = "Maximum number of ECS tasks allowed by auto scaling"
  type        = number
  default     = 6

  validation {
    condition     = var.max_capacity >= 1
    error_message = "Maximum capacity must be at least 1."
  }
}

variable "cpu_target_utilization" {
  description = "Target average ECS CPU utilization percentage"
  type        = number
  default     = 60

  validation {
    condition     = var.cpu_target_utilization > 0 && var.cpu_target_utilization <= 100
    error_message = "CPU utilization target must be greater than 0 and at most 100."
  }
}

variable "log_retention_days" {
  description = "CloudWatch Logs retention period in days"
  type        = number
  default     = 30

  validation {
    condition = contains(
      [1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653],
      var.log_retention_days
    )
    error_message = "Log retention must be a supported CloudWatch Logs retention period."
  }
}

variable "task_cpu" {
  description = "Fargate task CPU units"
  type        = number
  default     = 512

  validation {
    condition = contains(
      [256, 512, 1024, 2048, 4096, 8192, 16384],
      var.task_cpu
    )
    error_message = "Unsupported Fargate CPU value."
  }
}

variable "task_memory" {
  description = "Fargate task memory in MiB"
  type        = number
  default     = 1024

  validation {
    condition     = var.task_memory >= 512
    error_message = "Task memory must be at least 512 MiB."
  }
}
