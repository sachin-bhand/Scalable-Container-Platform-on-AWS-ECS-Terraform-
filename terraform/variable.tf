variable "region"{
    default= "ap-south-1"
}
variable "vpc_id" {
    default = "safle-app-vpc"   
  
}

variable "public_subnet_ids" {
  default = ["public_subnet-1","public_subnet-2"]
}

variable "private_subnet_ids" {
  default = ["private_subnet-1","private_subnet-2"]
}

variable "security_group_id" {
  default = "safle-sg"
}

variable "autoscaling_group_arn" {
    default = "arn:aws:autoscaling:ap-south-1:123456789012:autoScalingGroupName/safle-asg"  
  
}