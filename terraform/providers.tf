terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}

#// Configure Namecheap Provider
#provider "namecheap" {
#  username    = "your_username"
#  api_user    = "your_username" # Same as username
#  token       = "your_token"
#  ip          = "your.ip.address.here"
#  use_sandbox = false # Toggle for testing/sandbox mode
#}
