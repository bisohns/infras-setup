output "database_passwords" {
  description = "Database passwords"
  sensitive   = true
  value       = { for k, v in random_password.db_passwords : k => v.result }
}
