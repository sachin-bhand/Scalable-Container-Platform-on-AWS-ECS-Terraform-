
resource "aws_iam_role" "ecs_custom_role" {
  name = "ecs-custom-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = ["ecs.amazonaws.com", "ec2.amazonaws.com"]
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "ecs-instance-profile"
  role = aws_iam_role.ecs_custom_role.name
}

resource "aws_iam_policy" "ecs_custom_policy" {
  name        = "ecs-custom-policy"
  description = "Custom policy for ECS, ECR, EC2, CloudWatch Logs"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [


      {
        Effect = "Allow"
        Action = [
          "ec2:Describe*"
        ]
        Resource = "*"
      },

      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer",
          "ecr:DescribeRepositories",
          "ecr:ListImages"
        ]
        Resource = "*"
      },

    
      {
        Effect = "Allow"
        Action = [
          "ecs:CreateCluster",
          "ecs:RegisterContainerInstance",
          "ecs:Describe*",
          "ecs:List*",
          "ecs:TagResource"
        ]
        Resource = "*"
      }

    ]
  })
}

data "aws_iam_policy_document" "ecs_cloudwatch_full" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
      "cloudwatch:PutMetricData",
      "cloudwatch:GetMetricData",
      "cloudwatch:ListMetrics"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ecs_cloudwatch_policy" {
  name        = "ECSCloudWatchFullAccess"
  description = "Allows ECS to manage logs and metrics"
  policy      = data.aws_iam_policy_document.ecs_cloudwatch_full.json
}




resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.ecs_custom_role.name
  policy_arn = aws_iam_policy.ecs_custom_policy.arn

}


resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}




resource "aws_iam_role" "ecs_instance_role_1" {
  name = "ecsInstanceRole02"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = ["ec2.amazonaws.com", "ecs.amazonaws.com"]
      },
      Action = "sts:AssumeRole"
    }]
  })
}



resource "aws_iam_role_policy_attachment" "ecs_instance_role_attach" {
  role       = aws_iam_role.ecs_instance_role_1.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "ecs_instance_ssm" {
  role       = aws_iam_role.ecs_instance_role_1.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ecs_instance_ecr" {
  role       = aws_iam_role.ecs_instance_role_1.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "ecs_instance_cw_agent" {
  role       = aws_iam_role.ecs_instance_role_1.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}
resource "aws_iam_role_policy_attachment" "ecs_instance_ec2_container_service_role" {
  role       = aws_iam_role.ecs_instance_role_1.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

# attach admin policy to role
resource "aws_iam_role_policy_attachment" "ecs_instance_admin" {
  role       = aws_iam_role.ecs_instance_role_1.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}