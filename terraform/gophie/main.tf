locals {
  common_tags = {
    Environment = "production"
    Project     = var.project
    ManagedBy   = "Terraform"
  }

  db_name = "gophie"

  ocena_sensitive_vars = {
    "DATABASE_URL" = "postgres://${module.db.db_instance_username}:${module.db.db_instance_password}@${module.db.db_instance_endpoint}/${local.db_name}"
  }

  ocena_allowed_hosts = [
    "https://gophie.cam",
    "http://gophie-ocena.herokuapp.com",
    "http://localhost:3000",
    "https://gophie.netlify.app",
    "https://gophie-ssr.herokuapp.com",
    "https://gophie-statping.herokuapp.com",
    "https://ssr.gophie.cam",
    "https://new.gophie.cam"
  ]
}


resource "random_password" "db_password" {
  length  = 64
  special = false
}

module "remote_state_locking" {
  source      = "DeimosCloud/remote-state/aws"
  version     = "1.0.0"
  name_prefix = "gophie-terraform-state"
  use_lock    = false
}

module "ssh-key" {
  source = "../modules/terraform-ssh-key-pair"
}

module "key_pair" {
  source  = "terraform-aws-modules/key-pair/aws"
  version = "~> 0.6.0"

  public_key      = module.ssh-key.public_key
  key_name_prefix = var.project
  tags            = local.common_tags
}


// Gophie Web Security group
module "web_service_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.18"

  name        = "gophie-web"
  description = "Security group for Gophie Web"
  vpc_id      = data.aws_vpc.default.id

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
  subnet_id              = tolist(data.aws_subnet_ids.default.ids)[2]

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


module "config-frontend-server-ansible" {
  source = "../modules/terraform-ansible"

  scripts_dir          = "../../ansible"
  private_ssh_key_path = "../terraform/new_gophie/${module.ssh-key.private_key_path}"
  entry_script         = "frontend.yml"
  hosts                = [module.ec2.public_ip[0]]
  remote_user          = "ubuntu"
}

// Gophie Web Security group
module "database_service_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "database-access"
  description = "Security group for Gophie Postgres Database"
  vpc_id      = data.aws_vpc.default.id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "PostgreSQL access from within VPC"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  tags = local.common_tags
}

module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 3.0"

  identifier           = "${var.project}-db"
  engine               = "postgres"
  engine_version       = "12.5"
  family               = "postgres12" # DB parameter gr
  port                 = 5432
  major_engine_version = "12" # DB option group
  instance_class       = "db.t2.micro"
  snapshot_identifier  = "arn:aws:rds:eu-west-2:126759313825:snapshot:gophie-snapshot-26-05-2021"
  availability_zone    = "eu-west-2c"

  allocated_storage     = 20
  max_allocated_storage = 1000
  storage_encrypted     = false
  publicly_accessible   = true

  username = "postgres"
  password = random_password.db_password.result
  name     = local.db_name

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  iam_database_authentication_enabled = true

  vpc_security_group_ids = [module.database_service_sg.security_group_id]
  subnet_ids             = slice(tolist(data.aws_subnet_ids.default.ids), 0, 2)

  tags = local.common_tags

  # Database Deletion Protection
  deletion_protection = false

  depends_on = [module.database_service_sg]
}


module "ocena_heroku_app" {
  source                = "../modules/terraform-herokuapp"
  app_name              = "gophie-ocena"
  sensitive_config_vars = merge(var.ocena_config_vars, local.ocena_sensitive_vars)
  config_vars = {
    "DEBUG"           = "False"
    "ALLOWED_HOSTS"   = join(",", local.ocena_allowed_hosts)
    "GOPHIE_HOST"     = "https://deploy-gophie.herokuapp.com"
    "SCOUT_LOG_LEVEL" = "WARN"
    "SCOUT_MONITOR"   = "true"
  }

  depends_on = [module.db]
}
