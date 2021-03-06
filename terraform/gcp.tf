// Configure the GCP Provider
provider "google" {
  project = var.mythra_id
  region  = var.mythra_region
  zone    = var.mythra_zone
}

locals {
  m_common_tags = {
    Environment = "production"
    Project     = var.mythra_project
    ManagedBy = "Terraform"
  }
}

// Mythra Compute Engine Instance
resource "google_compute_instance" "vm_instance" {
  name         = "${var.mythra_project}-gcp"
  machine_type = "f1-micro"
  tags = locals.m_common_tags

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.self_link
    access_config {
    }
  }
}

// Mythra VPC Network
resource "google_compute_network" "vpc_network" {
  name                    = "${var.mythra_project}-terraform-network"
  auto_create_subnetworks = "true"
  tags = locals.m_common_tags
}
