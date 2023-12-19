variable "public_subnet_az1_id" {
  type        = string
  description = "(Required) Public Subnet AZ1 id"
}

variable "ssh_security_group_id" {
  type        = string
  description = "(Required) SSH security group id"
}

variable "webserver_security_group_id" {
  type        = string
  description = "(Required) webserver sevurity group id"
}

variable "alb_security_group_id" {
  type        = string
  description = "(Required) alb sevurity group id"
}

variable "efs_wordpress_dns_name" {
  type        = string
  description = "(Required) efs filesystem DNS name"
}

variable "rds_endpoint" {
  type        = string
  description = "(Required) rds_endpoint"
}

variable "database_name" {
  type        = string
  description = "(Required) database name"
}

variable "db_username" {
  type        = string
  description = "(Required) database username"
}

variable "db_password" {
  type        = string
  description = "(Required) database password"
}