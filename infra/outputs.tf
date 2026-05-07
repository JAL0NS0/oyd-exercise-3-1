output "ec2_instance_arn" {
  description = "The ARN of the EC2 module instance"
  value       = module.compute_ec2.instance_arn
}

output "app_public_ip" {
  description = "The public IP of the EC2 module instance"
  value       = module.compute_ec2.public_ip
}

output "health_check_url" {
  description = "URL to test the GET /health endpoint"
  value       = "http://${module.compute_ec2.public_ip}:8080/health"
}