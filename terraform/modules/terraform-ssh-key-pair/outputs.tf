output "private_key_path" {
  description = "The Path to the generated SSH Private Key"
  value       = local_file.private_key.filename
}

output "public_key" {
  description = "The Generated SSH Public Key"
  value       = tls_private_key.this.public_key_openssh
}
