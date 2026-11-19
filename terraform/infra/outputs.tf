# outputed so we can use it for cloudflare to redirect the domain to the ALB
output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

# data block to reference the resource from AWS 
data "aws_iam_role" "github_deploy" {
  name = "github-actions-deploy"

}

# reference the value here
output "github_actions_role_arn" {
  value = data.aws_iam_role.github_deploy.arn
}
