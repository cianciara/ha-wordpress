# Startup instance public ip
output "Startup_instance_public_ip" {
  value       = aws_instance.startup_instance.public_ip
  description = "Startup instance public IP"
}