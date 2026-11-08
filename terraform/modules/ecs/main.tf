resource "aws_ecs_cluster" "main" {
  name = "northstar-${var.environment}-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name        = "northstar-${var.environment}-ecs-cluster"
    Environment = var.environment
    Project     = "NorthStarRetail"
    ManagedBy   = "Terraform"
  }
}

resource "aws_cloudwatch_log_group" "reservation_service" {
  name              = "/ecs/northstar-${var.environment}-reservation-service"
  retention_in_days = var.log_retention_days

  tags = {
    Name        = "northstar-${var.environment}-reservation-logs"
    Environment = var.environment
    Project     = "NorthStarRetail"
    ManagedBy   = "Terraform"
  }
}

data "aws_region" "current" {}

resource "aws_ecs_task_definition" "reservation_service" {
  family                   = "northstar-${var.environment}-reservation-service"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  cpu    = tostring(var.task_cpu)
  memory = tostring(var.task_memory)

  lifecycle {
    precondition {
      condition = (
        (var.task_cpu == 256 && contains([512, 1024, 2048], var.task_memory)) ||
        (var.task_cpu == 512 && var.task_memory >= 1024 && var.task_memory <= 4096 && var.task_memory % 1024 == 0) ||
        (var.task_cpu == 1024 && var.task_memory >= 2048 && var.task_memory <= 8192 && var.task_memory % 1024 == 0) ||
        (var.task_cpu == 2048 && var.task_memory >= 4096 && var.task_memory <= 16384 && var.task_memory % 1024 == 0) ||
        (var.task_cpu == 4096 && var.task_memory >= 8192 && var.task_memory <= 30720 && var.task_memory % 1024 == 0) ||
        (var.task_cpu == 8192 && var.task_memory >= 16384 && var.task_memory <= 61440 && var.task_memory % 4096 == 0) ||
        (var.task_cpu == 16384 && var.task_memory >= 32768 && var.task_memory <= 122880 && var.task_memory % 8192 == 0)
      )
      error_message = "Unsupported AWS Fargate CPU and memory combination."
    }
  }

  execution_role_arn = var.ecs_execution_role_arn
  task_role_arn      = var.ecs_task_role_arn

  container_definitions = jsonencode([
    {
      name                   = "reservation-service"
      image                  = var.container_image
      essential              = true
      readonlyRootFilesystem = true
      user                   = "10001:10001"

      portMappings = [
        {
          containerPort = var.application_port
          hostPort      = var.application_port
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.reservation_service.name
          awslogs-region        = data.aws_region.current.region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  tags = {
    Name        = "northstar-${var.environment}-reservation-task"
    Environment = var.environment
    Project     = "NorthStarRetail"
    ManagedBy   = "Terraform"
  }
}

resource "aws_lb" "internal" {
  name               = "northstar-${var.environment}-internal-alb"
  internal           = true
  load_balancer_type = "application"

  security_groups = [var.alb_security_group_id]
  subnets         = var.private_subnet_ids

  enable_deletion_protection = var.environment == "prod"

  tags = {
    Name        = "northstar-${var.environment}-internal-alb"
    Environment = var.environment
    Project     = "NorthStarRetail"
    ManagedBy   = "Terraform"
  }
}

resource "aws_lb_target_group" "reservation_service" {
  name        = "northstar-${var.environment}-reservation"
  port        = var.application_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    enabled             = true
    path                = "/health"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  tags = {
    Name        = "northstar-${var.environment}-reservation-tg"
    Environment = var.environment
    Project     = "NorthStarRetail"
    ManagedBy   = "Terraform"
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.internal.arn
  port              = 443
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.reservation_service.arn
  }

  tags = {
    Name        = "northstar-${var.environment}-https-listener"
    Environment = var.environment
    Project     = "NorthStarRetail"
  }
}

resource "aws_ecs_service" "reservation_service" {
  name            = "northstar-${var.environment}-reservation-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.reservation_service.arn

  launch_type   = "FARGATE"
  desired_count = var.desired_count

  platform_version = "LATEST"

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [var.ecs_security_group_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.reservation_service.arn
    container_name   = "reservation-service"
    container_port   = var.application_port
  }

  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  health_check_grace_period_seconds  = 60

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  depends_on = [
    aws_lb_listener.https
  ]

  tags = {
    Name        = "northstar-${var.environment}-reservation-service"
    Environment = var.environment
    Project     = "NorthStarRetail"
    ManagedBy   = "Terraform"
  }
}

resource "aws_appautoscaling_target" "reservation_service" {
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.reservation_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  lifecycle {
    precondition {
      condition     = var.min_capacity <= var.max_capacity
      error_message = "Minimum capacity cannot exceed maximum capacity."
    }

    precondition {
      condition     = var.desired_count >= var.min_capacity && var.desired_count <= var.max_capacity
      error_message = "Desired count must be within the configured scaling range."
    }
  }
}

resource "aws_appautoscaling_policy" "reservation_cpu" {
  name               = "northstar-${var.environment}-reservation-cpu-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.reservation_service.resource_id
  scalable_dimension = aws_appautoscaling_target.reservation_service.scalable_dimension
  service_namespace  = aws_appautoscaling_target.reservation_service.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = var.cpu_target_utilization
    scale_out_cooldown = 60
    scale_in_cooldown  = 300
  }
}
