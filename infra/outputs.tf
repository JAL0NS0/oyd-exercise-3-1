output "instance_arn" {
  description = "The ARN of the EC2 module instance"
  value       = module.compute_ec2.instance_arn
}

output "public_ip" {
  description = "The public IP of the EC2 module instance"
  value       = module.compute_ec2.public_ip
}
