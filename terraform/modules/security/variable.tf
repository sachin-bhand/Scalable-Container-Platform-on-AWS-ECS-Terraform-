variable "vpc_id" {
    default = "safle-app-vpc"
  
}
variable "public_subnet_ids" {
  default = ["public_subnet-1","public_subnet-2"]
}
variable "private_subnet_ids" {
  default = ["private_subnet-1","private_subnet-2"]
}