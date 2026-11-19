# Needed to reference later
output "alb-security_id" {
  value = aws_security_group.alb.id

}

# Needed to reference this later
output "task-security_id" {
  value = aws_security_group.ecs_task.id

}
