locals {
  common_tags = {
    Terraform   = "true"
    Environment = "production"
    Project     = var.project
  }
}

// Generate Key Pair
resource "tls_private_key" "this" {
  algorithm = "RSA"
}


module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  public_key      = tls_private_key.this.public_key_openssh
  key_name_prefix = var.project
  tags            = local.common_tags
}

// SSH Private Key
resource "local_file" "private_key" {
  content         = tls_private_key.this.private_key_pem
  filename        = "./${var.project}-private-key.pem"
  file_permission = "0400"
}


// Gophie Web Security group
module "web_service_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "gophie-web"
  description = "Security group for Gophie Web"
  vpc_id      = data.aws_subnet.gophie.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp", "ssh-tcp", "http-80-tcp"]

  tags = local.common_tags
}


// EC2 Instance
module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.0"

  name           = "${var.project}-ec2"
  instance_count = 1

  ami                    = var.ec2_ami
  instance_type          = var.ec2_instance_type
  key_name               = module.key_pair.this_key_pair_key_name
  vpc_security_group_ids = [module.web_service_sg.this_security_group_id]
  subnet_id              = data.aws_subnet.gophie.id

  volume_tags = local.common_tags
  tags        = local.common_tags
}
