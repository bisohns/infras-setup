variable "project" {
  default = "gophie"
}

variable "aws_access_key" {
  description = "The AWS Access Key for the Gophie User Account"
}

variable "aws_secret_key" {
  description = "The AWS Secret Key for the Gophie User Account"
}

variable "ec2_instance_type" {
  default = "t2.micro"
}

variable "ec2_ami" {
  default = "ami-05c424d59413a2876"
}

variable "region" {
  default = "eu-west-2"
}

variable "domain_name" {
  default     = "gophie.cam"
  description = "domain name to update in A record for on Namecheap"
}

variable "heroku_api_key" {
  description = "(Required) Heroku API token. It must be provided, but it can also be sourced from env HEROKU_API_KEY variable."
}

variable "heroku_email" {
  description = "(Required) Email to be notified by Heroku. It must be provided, but it can also be sourced from HEROKU_EMAIL"
}

variable "ocena_config_vars" {
  default     = {}
  description = "Sensitive Variables to pass to the Ocena Heroku Application"
}
