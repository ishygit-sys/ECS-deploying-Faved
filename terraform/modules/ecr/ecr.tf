# Creating ECR repo where the image is stored
resource "aws_ecr_repository" "ecr_repo" {
  name                 = "ecs-project"
  image_tag_mutability = "MUTABLE"

  lifecycle {
    prevent_destroy = true # doesnt allow the ECR to be destroyed when there is an image inside

  }


  image_scanning_configuration { # scans the image
    scan_on_push = true
  }


}
