data "aws_subnet" "gophie" {
  id = var.subnet_id
}

data "archive_file" "ansible_dir" {
  type        = "zip"
  source_dir  = "../ansible"
  output_path = ".ansible.zip"
}
