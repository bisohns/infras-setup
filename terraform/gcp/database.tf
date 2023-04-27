resource "google_sql_database_instance" "main" {
  name             = "khidom-01"
  database_version = "POSTGRES_14"
  region           = "us-west1"

  settings {
    tier = "db-f1-micro"
  }
}
