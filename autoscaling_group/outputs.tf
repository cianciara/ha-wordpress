# Bastion Host public ip
output "bastion_host_public_ip" {
  value       = aws_instance.bastion_host.public_ip
  description = "Bastion host public IP"
}