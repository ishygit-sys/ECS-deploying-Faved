output "cluster_id" {
  value = aws_ecs_cluster.cluster.id
}

output "i_am_role_name" {
  value = aws_iam_role.role.name

}

output "i_am_role_arn" {
  value = aws_iam_role.role.arn

}

output "task_definition_arn" {
  value = aws_ecs_task_definition.service.arn

}

output "cloudwatch_log_group_name" {
  value = aws_cloudwatch_log_group.faved.name

}

