variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "app_name" {
  description = "Application name"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the chosen architecture"
  type        = string
}

variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
}

variable "allowed_cidr_blocks" {
  description = "List of allowed IP addresses in CIDR format"
  type        = list(string)
}

variable "app_s3_bucket" {
  description = "S3 bucket where server.rb is stored"
  type        = string
}