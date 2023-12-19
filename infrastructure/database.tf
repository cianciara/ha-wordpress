
# Database -----------------------------------------------------------------------

resource "aws_db_subnet_group" "database_subnets" {
  name       = "database_subnets"
  subnet_ids = [aws_subnet.private_data_subnet_az1.id, aws_subnet.private_app_subnet_az2.id]

  tags = {
    Name = "DB subnet group"
  }
}

resource "aws_db_instance" "wordpress_db" {
  allocated_storage      = 20
  db_name                = var.database_name
  identifier             = "dev-rds-db"
  db_subnet_group_name   = aws_db_subnet_group.database_subnets.name
  vpc_security_group_ids = [aws_security_group.database_sg.id]
  availability_zone      = data.aws_availability_zones.available.names[1]
  engine                 = "mysql"
  engine_version         = "5.7.44"
  instance_class         = "db.t3.micro"
  username               = var.db_username
  password               = var.db_password
  skip_final_snapshot    = true

  tags = {
    Name = "WordpressDB"
  }
}