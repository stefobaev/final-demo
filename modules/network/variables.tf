data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

variable "env" {
  description = "The environment of the project"
  default     = "main"
}

variable "app" {
  description = "The app of the project"
  default     = "app"
}

variable "aws_region" {
  description = "The AWS region for the project"
  default     = "eu-central-1"
}

variable "aws_profile" {
  description = "aws profile"
}
variable "cidr_block" {
  description = "The CIDR block of the project"
  default     = "10.0.0.0/16"
}

variable "aws_dns" {
  type    = bool
  default = true
}

locals {
  number_public_subnets  = 2
  number_private_subnets = 1
  azs                    = data.aws_availability_zones.available.names
}

variable "app_port" {
  description = "The application port"
  default     = 5000
}

variable "app_target_port" {
  description = "The application port"
  default     = 80
}

variable "health_check_path" {
  description = "The path for health check web servers"
  default     = "/"
}
data "aws_caller_identity" "current" {}

locals {
  aws_account_id = data.aws_caller_identity.current.account_id
}

variable "name_container" {
  description = "The container name"
  default     = "nginx"
}
variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  default     = "TaskExecutionRole"
}

variable "ecs_task_role_name" {
  description = "ECS task role name"
  default     = "TaskRole"
}

variable "web_server_image" {
  description = "The web server image to run in the ECS cluster"
  default     = "089370973671.dkr.ecr.eu-central-1.amazonaws.com/app-main-nginx"
}

variable "web_server_count" {
  description = "Number of web server containers to run"
  default     = 3
}

variable "web_server_fargate_cpu" {
  description = "Fargate instance CPU units to provision for web server (1 vCPU = 1024 CPU units)"
  default     = 1024
}

variable "web_server_fargate_memory" {
  description = "Fargate instance memory to provision for web server (in MiB)"
  default     = 2048
}

variable "ecr_repository_url" {
  type = string
}

variable "image_tag" {
  type = string
}

locals {
  image = format("%s:%s", var.ecr_repository_url, var.image_tag)
}

variable "taskdef_template" {
  default = "cb_app.json.tpl"
}

variable "remote_state_bucket" {}
