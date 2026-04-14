resource "aws_ecs_cluster" "safle-cluster" {
  name = "safle-cluster"
  tags = {
    Name = "safle-cluster"
  }
}



resource "aws_ecs_task_definition" "app_task" {
  family = "my-ec2-task-family"

  requires_compatibilities = ["EC2"]
  depends_on = [aws_cloudwatch_log_group.ecs_logs]

  container_definitions = jsonencode([
    {
      name      = "my-app-container"
      image     = "${var.repository_url}:latest"
      cpu       = 256 
      memory    = 512 
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 0
        }
      ]
      environment = [
        {
          name  = "DB_HOST"
          value = var.db_endpoint
        },
        {
          name  = "DB_USER"
          value = var.db_username
        },
        {
          name  = "DB_PASSWORD"
          value = var.db_password
        },
        {
          name  = "DB_NAME"
          value = var.db_name
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group" : "/ecs/my-ec2-task",
          "awslogs-region" : "ap-south-1", 
          "awslogs-stream-prefix" : "ecs",
          "awslogs-create-group"  :"true"
        }
      }
    }
  ])

  execution_role_arn  = var.task_execution_role_arn
  network_mode        = "bridge" 
}


resource "aws_cloudwatch_log_group" "ecs_logs" {
  name = "/ecs/my-ec2-task"
}




resource "aws_ecs_capacity_provider" "safle" {
  name = "safle-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn = var.autoscaling_group_arn

    managed_scaling {
      status = "ENABLED"
      target_capacity = 100
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "safle" {
  cluster_name = aws_ecs_cluster.safle-cluster.name

 capacity_providers = [
    aws_ecs_capacity_provider.safle.name
  ]
 default_capacity_provider_strategy {
  capacity_provider = aws_ecs_capacity_provider.safle.name
  weight            = 1
}

  depends_on = [
    aws_ecs_capacity_provider.safle
  ]
}



resource "aws_ecs_service" "app_service" {
  name            = "my-ec2-service"
  cluster         = aws_ecs_cluster.safle-cluster.id
  task_definition = aws_ecs_task_definition.app_task.arn
  desired_count   = 0

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.safle.name
    weight            = 1
    base              = 1
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "my-app-container" 
    container_port   = 3000                
  }
}
