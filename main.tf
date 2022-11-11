provider "aws" {
  region = var.aws_region
}

module "s3_terraform_state" {
  source      = "./modules/s3"
  bucket_name = var.bucket_name
}

module "ecr" {
  source              = "./modules/ecr"
  aws_region          = var.aws_region
  aws_profile         = var.aws_profile
  remote_state_bucket = var.bucket_name
  env                 = var.env
  app                 = var.app
  name_container      = var.name_container
  web_server_image    = var.web_server_image

}

module "init-build" {
  source              = "./modules/init-build"
  aws_region          = var.aws_region
  aws_profile         = var.aws_profile
  remote_state_bucket = var.bucket_name
  env                 = var.env
  app                 = var.app
  working_dir         = "${path.root}/app"
  image_tag           = var.image_tag
}

module "network" {
  source              = "./modules/network"
  aws_region          = var.aws_region
  aws_profile         = var.aws_profile
  remote_state_bucket = var.bucket_name
  cidr_block          = "10.0.0.0/16"
  aws_dns             = true
  env                 = var.env
  app                 = var.app
  app_port            = 80
  app_target_port     = 80
  health_check_path   = "/"
  name_container      = var.name_container
  web_server_image          = var.web_server_image
  image_tag                 = var.image_tag
  ecr_repository_url        = module.ecr.aws_ecr_repository_url
  taskdef_template          = "${path.root}/modules/network/cb_app.json.tpl"
  web_server_count          = 3
  web_server_fargate_cpu    = 1024
  web_server_fargate_memory = 2048
}

module "codebuild" {
  source              = "./modules/codebuild"
  aws_region          = var.aws_region
  aws_profile         = var.aws_profile
  remote_state_bucket = var.bucket_name
  env                 = var.env
  app                 = var.app
  vpc_id              = module.network.vpc_id
  subnets             = module.network.private_subnet_ids
  github_oauth_token  = var.github_oauth_token
  repo_url            = var.repo_url
  branch_pattern      = var.branch_pattern
  git_trigger_event   = var.git_trigger_event
  build_spec_file     = "config/buildspec.yml"
}