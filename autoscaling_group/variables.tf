variable "vpc_id" {
  type        = string
  description = "(Required) VPC id"
}

variable "public_subnet_az1_id" {
  type        = string
  description = "(Required) Public Subnet AZ1 id"
}

variable "public_subnet_az2_id" {
  type        = string
  description = "(Required) Public Subnet AZ2 id"
}

variable "private_app_subnet_az1_id" {
  type        = string
  description = "(Required) Private App Subnet AZ1 id"
}

variable "private_app_subnet_az2_id" {
  type        = string
  description = "(Required) Private App Subnet AZ2 id"
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

variable "domain_name" {
  type        = string
  description = "(Required) domain name"
}