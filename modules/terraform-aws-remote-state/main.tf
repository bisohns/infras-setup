data "aws_region" "current" {}
resource "random_id" "this" {
  byte_length = "10"
}

##### Locals
locals {
  bucket_name      = var.bucket_name != "" ? var.bucket_name : "${var.name_prefix}-${random_id.this.hex}"
  dynamo_lock_name = var.dynamo_lock_name != "" ? var.dynamo_lock_name : "${var.name_prefix}-lock-${random_id.this.hex}"
}

################# CREATING THE REMOTE S3 BUCKET
resource "aws_s3_bucket" "remote_state" {
  bucket        = local.bucket_name
  acl           = "private"
  force_destroy = var.force_destroy

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  versioning {
    enabled = var.enable_versioning
  }
}

################# CREATING THE DYNAMODB STATE LOCK  #######
resource "aws_dynamodb_table" "terraform_locks" {
  count        = var.use_lock ? 1 : 0
  name         = local.dynamo_lock_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}


################# AUTOMATING REMOTE STATE LOCKING
data "template_file" "remote_state" {
  template = "${file("${path.module}/templates/remote_state.tpl")}"
  vars = {
    remote_state_bucket = aws_s3_bucket.remote_state.bucket
    bucket_region       = data.aws_region.current.name
    bucket_key          = var.bucket_key
    dynamodb_table      = local.dynamo_lock_name
    use_lock            = var.use_lock
  }

  depends_on = [aws_dynamodb_table.terraform_locks]
}

resource "local_file" "backend_remote_state" {
  content  = data.template_file.remote_state.rendered
  filename = var.backend_output_path
}
