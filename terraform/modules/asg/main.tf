
data "aws_ami" "ecs_optimized" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }

  owners = ["amazon"]
}

resource "aws_launch_template" "safle_template" {
  name_prefix   = "ec2-cluster-"
  image_id      = data.aws_ami.ecs_optimized.id

  instance_type = "t3.micro"

  key_name = "saflekey"

  iam_instance_profile {
    name = var.instance_profile_name
  }
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "optional"
  }

  user_data = base64encode(<<-EOF
#!/bin/bash
echo ECS_CLUSTER=safle-cluster >> /etc/ecs/ecs.config
systemctl stop ecs
systemctl start ecs
EOF
)

  vpc_security_group_ids = [var.security_group_id]
}

resource "aws_autoscaling_group" "safle-asg" {
  desired_capacity    = 0
  max_size            = 5
  min_size            = 0
  vpc_zone_identifier = var.private_subnet_ids

  launch_template {
    id      = aws_launch_template.safle_template.id
    version = "$Latest"
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = "true"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.safle-asg.id
  lb_target_group_arn    = var.target_group_arn
}