# EFS dns name
output "efs_dns_name" {
  value       = aws_efs_file_system.wordpress.dns_name
  description = "EFS dns name to mount efs with wordpress"
}

# RDS instance endpoint
output "rds_endpoint" {
  value = aws_db_instance.wordpress_db.endpoint
}

# VPC id
output "vpc_wordpress_id" {
  value = aws_vpc.wordpress.id
}

# Public subnet AZ1 id
output "public_subnetAZ1_id" {
  value = aws_subnet.public_subnet_az1.id
}

# Public subnet AZ2 id
output "public_subnetAZ2_id" {
  value = aws_subnet.public_subnet_az2.id
}

# Private app subnet AZ1 id
output "private_app_subnetAZ1_id" {
  value = aws_subnet.private_app_subnet_az1.id
}

# Private app subnet AZ2 id
output "private_app_subnetAZ2_id" {
  value = aws_subnet.private_app_subnet_az2.id
}

# Private data subnet AZ1 id
output "private_data_subnetAZ1" {
  value = aws_subnet.private_data_subnet_az1.id
}

# Private data subnet AZ2 id
output "private_data_subnetAZ2" {
  value = aws_subnet.private_data_subnet_az2.id
}

# SSH security group id
output "ssh_security_group_id" {
  value = aws_security_group.ssh_sg.id
}

# Webserver security group id
output "webserver_security_group_id" {
  value = aws_security_group.webserver_sg.id
}

# ALB security group id
output "alb_security_group_id" {
  value = aws_security_group.alb_sg.id
}

# Database security group id
output "database_security_group_id" {
  value = aws_security_group.database_sg.id
}

# EFS security group id
output "efs_security_group_id" {
  value = aws_security_group.efs_sg.id
}