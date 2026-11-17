output "ecr_repo_id" {
  value = aws_ecr_repository.ecr_repo.id

}


output "repository_url" {
  value = aws_ecr_repository.ecr_repo.repository_url
}
