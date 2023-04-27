resource "random_password" "db_passwords" {
  for_each = toset(local.database_users)
  length   = 24
  special  = false
}

resource "google_compute_global_address" "db_private_ip_address" {
  name          = "pg-private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.khidom_01.id
}


resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.khidom_01.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.db_private_ip_address.name]
}

resource "google_sql_database_instance" "main" {
  name             = "pg-01"
  database_version = "POSTGRES_14"
  region           = "us-west1"

  settings {
    tier                        = "db-f1-micro"
    availability_type           = "ZONAL"
    deletion_protection_enabled = true

    ip_configuration {
      ipv4_enabled                                  = true
      private_network                               = google_compute_network.khidom_01.id
      enable_private_path_for_google_cloud_services = true

      authorized_networks {
        name  = "Global"
        value = "0.0.0.0/0"
      }
    }
  }

  deletion_protection = true

  depends_on = [google_service_networking_connection.private_vpc_connection]
}

resource "google_sql_user" "users" {
  for_each = toset(local.database_users)
  name     = each.value
  instance = google_sql_database_instance.main.name
  password = random_password.db_passwords[each.value].result
}

resource "google_sql_database" "databases" {
  for_each = toset(local.databases)
  name     = each.value
  instance = google_sql_database_instance.main.name
}
