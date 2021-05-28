data "archive_file" "scripts_dir" {
  type        = "zip"
  source_dir  = var.scripts_dir
  output_path = ".ansible.zip"
}

resource "null_resource" "config-ansible" {
  triggers = {
    "src_hash" = data.archive_file.scripts_dir.output_sha # track changes in the ansible dir
  }

  provisioner "local-exec" {
    working_dir = var.scripts_dir
    environment = {
      ANSIBLE_HOST_KEY_CHECKING = "False"
    }
    command = <<CMD
      sleep 60
      ansible-playbook -u ${var.remote_user} --private-key ${var.private_ssh_key_path}  -i '${join(",", var.hosts)},' ${var.entry_script}
    CMD
  }
}
