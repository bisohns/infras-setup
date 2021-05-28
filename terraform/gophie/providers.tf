terraform {
  required_version = "~> 0.15.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0, < 4.0"
    }
    heroku = {
      source  = "heroku/heroku"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region     = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# Configure the Heroku provider
provider "heroku" {
  email   = var.heroku_email
  api_key = var.heroku_api_key
}
