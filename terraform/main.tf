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
  egress_rules        = ["all-all"]

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

# TODO Wait for Namecheap provider to be deployed to terraform registry for terraform 13+ and implement this function
# https://github.com/adamdecaf/terraform-provider-namecheap
#// DNS Configuration
#// Add/Update Namecheap domain with ec2 IP address
#resource "namecheap_record" "www-domain" {
#  name    = "www"
#  domain  = var.domain_name
#  address = "https://${domain_name}"
#  mx_pref = 10
#  type    = "URL Redirect"
#}

#resource "namecheap_record" "apex-domain" {
#  name    = "@"
#  domain  = var.domain_name
#  address = module.ec2.public_ip[0]
#  mx_pref = 10
#  type    = "A"
#}


resource null_resource "config-server-ansible" {
  triggers = {
    "src_hash" = "${data.archive_file.ansible_dir.output_sha}" # track changes in the ansible dir
  }
  provisioner "local-exec" {
    working_dir = "../ansible"
    environment = {
      ANSIBLE_HOST_KEY_CHECKING = "False"
    }
    command = <<CMD
      sleep 60
      ansible-playbook -u ubuntu --private-key ../terraform/gophie-private-key.pem  -i '${module.ec2.public_ip[0]},' main.yml
    CMD
  }
}
