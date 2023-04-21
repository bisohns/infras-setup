resource "google_compute_network" "khidom_01" {
  name                    = "khidom-01"
  description             = "The VPC for hosting Khidom Resources"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "gke" {
  name          = "gke-01"
  ip_cidr_range = "10.10.0.0/20"
  region        = "us-west1"
  network       = google_compute_network.khidom_01.id
}

