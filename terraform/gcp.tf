// Mythra IP Address
resource "google_compute_address" "static" {
  name   = "${var.mythra_project}-ipv4-address"
}

// Mythra Compute Engine Instance
resource "google_compute_instance" "vm_instance" {
  count        = 1
  name         = "${var.mythra_project}-ce"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  metadata = {
    ssh-keys = "gcp:${tls_private_key.this.public_key_openssh}"
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.static.address
    }
  }
}

resource null_resource "config-mythra-server-ansible" {
  triggers = {
    "src_hash" = data.archive_file.ansible_dir.output_sha # track changes in the ansible dir
  }
  provisioner "local-exec" {
    working_dir = "../ansible"
    environment = {
      ANSIBLE_HOST_KEY_CHECKING = "False"
    }
    command = <<CMD
#      sleep 60
      ansible-playbook -u gcp --private-key ../terraform/gophie-private-key.pem  -i '${google_compute_address.static.address},' mythra.yml
    CMD
  }
}
