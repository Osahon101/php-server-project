resource "aws_db_subnet_group" "prod_db_subnet_group" {
  name       = "prod-db-subnet-group"
  subnet_ids = var.db_subnet_ids

  tags = {
    Name = "prod-db-subnet-group"
  }
}

resource "aws_db_instance" "prod_database" {
  allocated_storage    = 30
  storage_type        = "gp3"
  engine              = "mysql"
  engine_version      = "5.7"
  instance_class      = "db.t2.micro"
  name                = "prod-database"
  username            = var.db_username
  password            = var.db_password
  skip_final_snapshot = true
  multi_az = true
  vpc_security_group_ids = [var.db_security_group_id]
  db_subnet_group_name   = aws_db_subnet_group.prod_db_subnet_group.name
  publicly_accessible   = false
  storage_encrypted     = true
  backup_retention_period = 7
  backup_window         = "04:00-05:00"

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  tags = {
    Name = "prod-database"
  }
}

