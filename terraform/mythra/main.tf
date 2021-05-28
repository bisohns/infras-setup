locals {
  common_labels = {
    Environment = "production"
    Project     = var.project
    ManagedBy   = "Terraform"
  }
}

module "ssh-key" {
  source = "../modules/terraform-ssh-key-pair"
}


// Mythra IP Address
resource "google_compute_address" "mythra_static_ip" {
  name = "${var.project}-ipv4-address"
}

// Mythra Compute Engine Instance
resource "google_compute_instance" "mythra_vm" {
  count        = 1
  name         = "${var.project}-ce"
  machine_type = "f1-micro"

  tags = ["http-server", "https-server"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  metadata = {
    ssh-keys = "gcp:${module.ssh-key.public_key}"
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.mythra_static_ip.address
    }
  }
}

resource "google_compute_firewall" "default" {
  name    = "allow-http-and-https"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

}
