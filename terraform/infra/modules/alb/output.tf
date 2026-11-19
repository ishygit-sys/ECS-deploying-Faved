output "alb_id" {
  value = aws_lb.main.id
}


output "alb_arn" {
  value = aws_lb.main.arn
}


output "target_group_id" {
  value = aws_lb_target_group.target-g.id
}


output "target_group_arn" {
  value = aws_lb_target_group.target-g.arn
}


output "https_listener_arn" {
  value = aws_lb_listener.https.arn
}

output "alb_dns_name" {
  value = aws_lb.main.dns_name
}

output "alb_zone_id" {
  value = aws_lb.main.zone_id
}
