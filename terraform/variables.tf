variable "project" {
  default = "gophie"
}

variable "ec2_instance_type" {
  default = "t2.micro"
}

variable "ec2_ami" {
  default = "ami-05c424d59413a2876"
}

variable "subnet_id" {
  default = "subnet-00c0684c"
}

variable "region" {
  default = "eu-west-2"
}

variable "domain_name" {
  default     = "gophie.cam"
  description = "domain name to update in A record for on Namecheap"
}
