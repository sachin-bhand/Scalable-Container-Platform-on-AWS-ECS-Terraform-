module "vpc" {
  source = "./modules/vpc"
}

module "alb" {
  source = "./modules/alb"
  security_group_id = module.security.security_group_id
  public_subnet_ids = module.vpc.public_subnet_ids
  vpc_id = module.vpc.vpc_id
}

module "asg" {
  source = "./modules/asg"
  private_subnet_ids = module.vpc.private_subnet_ids
  target_group_arn = module.alb.target_group_arn
  instance_profile_name = module.iam.instance_profile_name
  security_group_id = module.security.security_group_id
}

module "security" {
  source = "./modules/security"
  vpc_id = module.vpc.vpc_id
}

module "ecs" {
  source = "./modules/ecs"
  repository_url = module.ecr.repository_url
  task_execution_role_arn = module.iam.task_execution_role_arn
  autoscaling_group_arn = module.asg.autoscaling_group_arn
  target_group_arn = module.alb.target_group_arn
  db_endpoint = module.rds.db_endpoint
}

module "rds" {
  source = "./modules/rds"
  vpc_id = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  security_group_id = module.security.security_group_id
}

module "iam" {
  source = "./modules/iam"  
}

module "ecr" {
  source = "./modules/ecr"
  
}

