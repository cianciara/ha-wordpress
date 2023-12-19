# EFS -------------------------------------------------------------------------------

resource "aws_efs_file_system" "wordpress" {
  creation_token = "wordpress"

  tags = {
    Name = "Dev-EFS"
  }
}

resource "aws_efs_mount_target" "efs_mount_az1" {
  file_system_id  = aws_efs_file_system.wordpress.id
  subnet_id       = aws_subnet.private_app_subnet_az1.id
  security_groups = [aws_security_group.efs_sg.id]
}

resource "aws_efs_mount_target" "efs_mount_az2" {
  file_system_id  = aws_efs_file_system.wordpress.id
  subnet_id       = aws_subnet.private_app_subnet_az2.id
  security_groups = [aws_security_group.efs_sg.id]
}