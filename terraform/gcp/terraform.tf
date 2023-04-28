terraform {
  backend "gcs" {
    bucket = "khidom-terraform-state"
    prefix = "global/terrform"
  }
  required_version = "~> 1.4"
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 4.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = "us-west1"
}

provider "google-beta" {
  project = var.project_id
  region  = "us-west1"
}
