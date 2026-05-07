variable "environment" {
    description = "The environment for the EC2 instance (e.g., dev, staging, prod)"
    type        = string
    default     = "dev"
}

variable "name" {
    description = "The name for the EC2 instance"
    type        = string
}

variable "ami_id" {
    description = "The AMI ID to use for the EC2 instance"
    type        = string
}

variable "instance_type" {
    description = "The instance type for the EC2 instance"
    type        = string
    default     = "t3.micro"
}

variable "allowed_cidr_blocks" {
    description = "List of CIDR blocks allowed to access the EC2 instance"
    type        = list(string)
}

variable "app_s3_bucket" {
    description = "The S3 bucket name for application storage"
    type        = string
}