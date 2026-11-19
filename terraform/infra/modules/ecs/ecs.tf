# Creatimg Ecs cluster 
resource "aws_ecs_cluster" "cluster" {
  name = "ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# creating IAM role
resource "aws_iam_role" "role" {
  name = "ecs_role"


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

# Attatching policies to the role
resource "aws_iam_role_policy_attachment" "role_attatchment" {
  role       = aws_iam_role.role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


# Captures and stores container application logs for 7 days for monitoring and debugging
resource "aws_cloudwatch_log_group" "faved" {
  name              = "/ecs/faved-task"
  retention_in_days = 7
}

# Defines the Fargate container blueprint (0.5 vCPU, 1 GB RAM), ECR image tag, port 8080 mapping, and CloudWatch logging
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





# Runs and maintains 1 Fargate container task in the public subnets, registering it with the ALB target group
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
