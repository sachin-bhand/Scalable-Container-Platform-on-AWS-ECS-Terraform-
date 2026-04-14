variable "public_subnet_ids" {
  default = ["public_subnet-1","public_subnet-2"]
}

variable "security_group_id" {
  default = "safle-sg"
}

variable "vpc_id" {
}
