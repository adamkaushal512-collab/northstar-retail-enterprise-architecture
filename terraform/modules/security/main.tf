data "aws_vpc" "selected" {
  id = var.vpc_id
}

resource "aws_security_group" "alb" {
  name_prefix = "northstar-${var.environment}-alb-"
  description = "Security group for internal Application Load Balancer"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTPS traffic from within the VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.selected.cidr_block]
  }

  tags = {
    Name        = "northstar-${var.environment}-alb-sg"
    Environment = var.environment
    Project     = "NorthStarRetail"
  }
}

resource "aws_security_group" "ecs" {
  name_prefix = "northstar-${var.environment}-ecs-"
  description = "Security group for ECS Reservation Service"
  vpc_id      = var.vpc_id


  tags = {
    Name        = "northstar-${var.environment}-ecs-sg"
    Environment = var.environment
    Project     = "NorthStarRetail"
  }
}

data "aws_iam_policy_document" "ecs_execution_assume_role" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_execution" {
  name               = "northstar-${var.environment}-ecs-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_execution_assume_role.json

  tags = {
    Environment = var.environment
    Project     = "NorthStarRetail"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_execution" {
  role       = aws_iam_role.ecs_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecs_task" {
  name               = "northstar-${var.environment}-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_execution_assume_role.json

  tags = {
    Environment = var.environment
    Project     = "NorthStarRetail"
  }
}

data "aws_iam_policy_document" "reservation_dynamodb" {
  statement {
    sid    = "ReservationTableAccess"
    effect = "Allow"

    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:Query",
      "dynamodb:TransactWriteItems"
    ]

    resources = concat(
      var.dynamodb_table_arns,
      [for arn in var.dynamodb_table_arns : "${arn}/index/*"]
    )
  }
}

resource "aws_iam_role_policy" "reservation_dynamodb" {
  name   = "northstar-${var.environment}-reservation-dynamodb"
  role   = aws_iam_role.ecs_task.id
  policy = data.aws_iam_policy_document.reservation_dynamodb.json
}

resource "aws_vpc_security_group_egress_rule" "alb_to_ecs" {
  security_group_id            = aws_security_group.alb.id
  referenced_security_group_id = aws_security_group.ecs.id

  ip_protocol = "tcp"
  from_port   = var.application_port
  to_port     = var.application_port

  description = "Allow internal ALB to reach ECS Reservation Service"

  tags = {
    Name        = "northstar-${var.environment}-alb-to-ecs"
    Environment = var.environment
    Project     = "NorthStarRetail"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ecs_from_alb" {
  security_group_id            = aws_security_group.ecs.id
  referenced_security_group_id = aws_security_group.alb.id

  ip_protocol = "tcp"
  from_port   = var.application_port
  to_port     = var.application_port

  description = "Allow Reservation Service traffic only from internal ALB"

  tags = {
    Name        = "northstar-${var.environment}-ecs-from-alb"
    Environment = var.environment
    Project     = "NorthStarRetail"
  }
}

# Explicit egress; restrict this after verifying ECR, logs, DynamoDB, S3, DNS and application dependencies.
resource "aws_vpc_security_group_egress_rule" "ecs_https" {
  security_group_id = aws_security_group.ecs.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  description       = "HTTPS egress pending dependency-specific hardening"
}
