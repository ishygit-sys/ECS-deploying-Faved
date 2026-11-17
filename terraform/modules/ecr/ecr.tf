# import {
# to = aws_ecr_repository.my_imported_repo
#  id = "hello/ecs"

# }


# resource "aws_ecr_repository" "my_imported_repo" {
# left blank for now
# name = "hello/ecs"
# }

resource "aws_ecr_repository" "ecr_repo" {
  name                 = "ecs-project"
  image_tag_mutability = "MUTABLE"

  lifecycle {
    prevent_destroy = true

  }


  image_scanning_configuration {
    scan_on_push = true
  }


}
