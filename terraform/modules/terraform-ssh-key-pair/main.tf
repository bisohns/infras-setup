locals {
  filename = var.output_file_path == null ? "${path.root}/private-key.pem" : var.output_file_path
}

// Generate Key Pair
resource "tls_private_key" "this" {
  algorithm = var.algorithm
}

// SSH Private Key
resource "local_file" "private_key" {
  content         = tls_private_key.this.private_key_pem
  filename        = local.filename
  file_permission = var.file_permission
}
