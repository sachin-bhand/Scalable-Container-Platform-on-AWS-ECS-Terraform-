variable "vpc_id" {
  description = "VPC ID where RDS will be deployed"
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for RDS subnet group"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID for RDS"
}

variable "db_name" {
  description = "Database name"
  default     = "safle_db"
}

variable "db_username" {
  description = "Database username"
  default     = "admin"
}

variable "db_password" {
  description = "Database password"
  default     = "password123"  # In production, use secrets manager
}

variable "db_instance_class" {
  description = "RDS instance class"
  default     = "db.t3.micro"
}

variable "db_engine" {
  description = "Database engine"
  default     = "mysql"
}

variable "db_engine_version" {
  description = "Database engine version"
  default     = "8.0"
}