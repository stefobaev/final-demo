
variable "bucket_name" {
  type        = string
  description = "S3 Bucket name"
  default     = "nginx-stage-eu-central-1"
}

variable "aws_region" {
  default = "eu-central-1"
}

variable "aws_profile" {
  default = "baev"
}

variable "aws_account" {
  type    = string
  default = "089370973671"
}

variable "env" {
  type    = string
  default = "main"
}

variable "app" {
  type    = string
  default = "app"
}

variable "name_container" {
  default = "nginx"
}

variable "web_server_image" {
  default = "089370973671.dkr.ecr.eu-central-1.amazonaws.com/app-main-nginx"
}

variable "image_tag" {
  type    = string
  default = "0.0.1"
}

variable "github_oauth_token" {
  type    = string
  default = ""
}

variable "repo_url" {
  type    = string
  default = "hhttps://github.com/stefobaev/final-demo.git"
}

variable "branch_pattern" {
  type    = string
  default = "main"
}

variable "git_trigger_event" {
  type    = string
  default = "PUSH"
}

variable "app_count" {
  default = 1
}
