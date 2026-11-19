# outputed so we can use it for cloudflare to redirect the domain to the ALB
output "alb_dns_name" {
  value = module.alb.alb_dns_name
}



output "github_actions_role_arn" {
  value = aws_iam_role.github_deploy.arn
}
