# Creating ECR repo where the image is stored
resource "aws_ecr_repository" "ecr_repo" {
  name                 = "ecs-project"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration { # scans the image
    scan_on_push = true
  }


}
