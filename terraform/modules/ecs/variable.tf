variable "asg-arn" {
    default = "arn:aws:autoscaling:ap-south-1:123456789012:autoScalingGroupName/safle-asg"
  
}

variable "repository_url" {
}

variable "task_execution_role_arn" {
}

variable "autoscaling_group_arn" {
}

variable "target_group_arn" {
}

variable "db_endpoint" {
  description = "RDS database endpoint"
}

variable "db_username" {
  description = "Database username"
  default     = "admin"
}

variable "db_password" {
  description = "Database password"
  default     = "password123"
}

variable "db_name" {
  description = "Database name"
  default     = "safle_db"
}