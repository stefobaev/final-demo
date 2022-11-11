output "ecr_repository_url" {
  value = module.ecr.aws_ecr_repository_url
}
output "confirmation" {
  value = module.init-build.confirmation
}
output "alb_hostname" {
  value = module.network.alb_hostname
}
