module "vpc" {
  source = "./modules/vpc"
}

module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = module.vpc.vpc_id


}

module "alb" {
  source          = "./modules/alb"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.subnet_ids
  alb-security_id = module.security_groups.alb-security_id
  cert_arn        = module.acm.cert_arn


}

module "acm" {
  source       = "./modules/acm"
  alb_dns_name = module.alb.alb_dns_name
}

module "ecs" {
  source           = "./modules/ecs"
  target_group_arn = module.alb.target_group_arn
  subnet_ids       = module.vpc.subnet_ids
  alb_id           = module.alb.alb_id
  task-security_id = module.security_groups.task-security_id
  repository_url   = module.ecr.repository_url
  depends_on       = [module.alb]
  image_tag        = var.image_tag

}

module "ecr" {
  source = "./modules/ecr"

}



