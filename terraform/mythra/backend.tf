terraform {
  backend "gcs" {
    bucket      = "terraform-mythra-state-000"
    prefix      = "global/terrform.tfstate"
    credentials = "sa.json"
  }
}
