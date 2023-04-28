resource "google_container_cluster" "primary" {
  name     = "khidom-gke-01"
  location = "us-west1-a"

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "10.1.0.0/16"
    services_ipv4_cidr_block = "172.20.0.0/20"
  }

  networking_mode = "VPC_NATIVE"
  network         = google_compute_network.khidom_01.id
  subnetwork      = google_compute_subnetwork.gke.id

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

}

resource "google_service_account" "node_pool" {
  account_id   = "gke-node-pool"
  display_name = "GKE Node pool Service Account"
}

resource "google_container_node_pool" "default" {
  name     = "default-node-pool-01"
  location = "us-west1-a"
  node_locations = [
    "us-west1-a"
  ]
  cluster    = google_container_cluster.primary.name
  node_count = 2

  node_config {
    preemptible  = true
    machine_type = "e2-medium"

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.node_pool.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    workload_metadata {
      mode = "GKE_METADATA"
    }
  }
  lifecycle {
    ignore_changes = [initial_node_count]
  }
}
