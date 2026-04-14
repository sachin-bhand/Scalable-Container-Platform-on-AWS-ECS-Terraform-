resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "RDS subnet group"
  }
}

resource "aws_db_instance" "safle_db" {
  identifier             = "safle-db"
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  instance_class         = var.db_instance_class
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  allocated_storage      = 20
  storage_type           = "gp2"
  publicly_accessible    = false
  vpc_security_group_ids = [var.security_group_id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  skip_final_snapshot    = true

  tags = {
    Name = "Safle Database"
  }
}