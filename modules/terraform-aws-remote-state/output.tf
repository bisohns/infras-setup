output "bucket_name" {
  value       = aws_s3_bucket.remote_state.id
  description = "bucket name"
}

output "dynamodb_table" {
  value       = aws_dynamodb_table.terraform_locks.*.id
  description = "Dynamodb name"
}

