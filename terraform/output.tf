output "ec2_public_ip" {
  value       = module.ec2.*.public_ip
  description = "IP of created instances"
}

output "ec2_public_dns" {
  value       = module.ec2.*.public_dns
  description = "Public DNS of created instances"
}

