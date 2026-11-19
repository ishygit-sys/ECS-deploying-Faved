


resource "aws_ecs_cluster" "cluster" {
  name = "ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_iam_role" "role" {
  name = "ecs_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "role_attatchment" {
  role       = aws_iam_role.role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}



resource "aws_cloudwatch_log_group" "faved" {
  name              = "/ecs/faved-task"
  retention_in_days = 7
}

resource "aws_ecs_task_definition" "service" {
  family                   = "ecs-service"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = aws_iam_role.role.arn

  container_definitions = jsonencode([
    {
      name      = "my-app-container"
      image     = "${var.repository_url}:${var.image_tag}"
      essential = true

      portMappings = [
        {
          containerPort = 8080
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.faved.name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}






resource "aws_ecs_service" "service" {
  name                  = "ecs-service"
  cluster               = aws_ecs_cluster.cluster.id
  task_definition       = aws_ecs_task_definition.service.arn
  launch_type           = "FARGATE"
  desired_count         = 1
  wait_for_steady_state = true


  load_balancer {

    container_name   = "my-app-container"
    container_port   = 8080
    target_group_arn = var.target_group_arn
  }
  network_configuration {
    security_groups  = [var.task-security_id]
    subnets          = var.subnet_ids
    assign_public_ip = true

  }
}
