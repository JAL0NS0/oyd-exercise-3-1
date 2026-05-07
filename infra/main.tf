module "compute_ec2" {
  source = "./modules/compute_ec2"

  # Conectando las variables del Root Module hacia el Child Module
  environment         = var.environment
  name                = var.app_name
  ami_id              = var.ami_id
  instance_type       = var.instance_type
  allowed_cidr_blocks = var.allowed_cidr_blocks
  app_s3_bucket       = var.app_s3_bucket
}