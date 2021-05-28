output "ec2_public_ip" {
  value       = module.ec2.*.public_ip
  description = "IP of created instances"
}

output "ec2_public_dns" {
  value       = module.ec2.*.public_dns
  description = "Public DNS of created instances"
}

output "db_instance_address" {
  value = module.db.db_instance_address
}

output "db_instance_endpoint" {
  value = module.db.db_instance_endpoint
}

output "db_master_password" {
  value = nonsensitive(module.db.db_instance_password)
}
