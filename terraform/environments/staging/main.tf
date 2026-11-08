locals { environment = "staging" }
module "networking" {
  source                     = "../../modules/networking"
  environment                = local.environment
  vpc_cidr                   = "10.30.0.0/16"
  availability_zones         = var.availability_zones
  enable_interface_endpoints = var.enable_interface_endpoints
}
module "dynamodb" {
  source      = "../../modules/dynamodb"
  environment = local.environment
}
module "eventbridge" {
  source      = "../../modules/eventbridge"
  environment = local.environment
}
module "security" {
  source              = "../../modules/security"
  environment         = local.environment
  vpc_id              = module.networking.vpc_id
  dynamodb_table_arns = module.dynamodb.table_arns
  alb_certificate_arn = var.alb_certificate_arn
}
module "ecs" {
  source                 = "../../modules/ecs"
  environment            = local.environment
  vpc_id                 = module.networking.vpc_id
  private_subnet_ids     = module.networking.private_subnet_ids
  alb_security_group_id  = module.security.alb_security_group_id
  ecs_security_group_id  = module.security.ecs_security_group_id
  ecs_execution_role_arn = module.security.ecs_execution_role_arn
  ecs_task_role_arn      = module.security.ecs_task_role_arn
  certificate_arn        = module.security.alb_certificate_arn
  container_image        = var.container_image
  task_cpu               = 512
  task_memory            = 1024
  desired_count          = 2
  min_capacity           = 2
  max_capacity           = 4
}
