# =============================================================================
# terraform_integration_templates :: terraform/aws/environment/dev/09.elasticache/elasticache.main.tf
#       :: mdunbar :: 2025 Dec 01 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
module "elasticache" {
  source = "terraform-aws-modules/elasticache/aws"

  replication_group_id = local.name

  engine         = "valkey"
  engine_version = "7.2"
  node_type      = "cache.t4g.micro"

  # Cluster Configuration
  auth_token                 = aws_secretsmanager_secret_version.valkey_auth.secret_string
  at_rest_encryption_enabled = true
  transit_encryption_enabled = true
  maintenance_window         = "sun:05:00-sun:09:00"
  apply_immediately          = true

  # Replication Group
  cluster_mode_enabled       = false     # prod should be true with multiple node groups
  num_node_groups            = 1         # prod should be more than 1 with cluster_mode_enabled true
  replicas_per_node_group    = 0         # prod should be at least 1
  automatic_failover_enabled = false     # prod should be true with replicas

  # Security Group
  vpc_id = data.aws_vpc.dev_vpc.id
  security_group_rules = {
    ingress_vpc = {
      # Default type is `ingress`
      # Default port is based on the default engine port
      description = "VPC traffic"
      cidr_ipv4   = data.aws_vpc.dev_vpc.cidr_block
    }
  }

  # Subnet Group
  subnet_group_name        = local.name
  subnet_group_description = "Valkey replication group subnet group"
  subnet_ids               = data.terraform_remote_state.vpc.outputs.private_subnets

  # Parameter Group
  create_parameter_group      = true
  parameter_group_name        = local.name
  parameter_group_family      = "valkey7"
  parameter_group_description = "Valkey replication group parameter group"
  parameters = [
    {
      name  = "latency-tracking"
      value = "yes"
    }
  ]

  tags = local.tags
}

# We are absolutely NOT setting a plaintext password for valkey access that is then committed forever to git`
# We will instead create a more secure Secrets Manager-based solution
# Generate a secure random password for ElastiCache auth token
resource "random_password" "valkey_auth" {
  length  = 64
  special = false                   # true is preferred, but some special characters may cause issues, and 
  # override_special = "-_=+;:,."   # recent versions of terraform may not reliably honor override_special
}

# Store the ElastiCache auth token in Secrets Manager as a SecureString
resource "aws_secretsmanager_secret" "valkey_auth" {
  name                    = "/elasticache/valkey/${var.environment}/auth-token"
  recovery_window_in_days = 7

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Environment = var.environment
    Name        = "/elasticache/valkey/${var.environment}/auth-token"
  }
}

# Retrieve the ElastiCache auth token from Secrets Manager, so it can be used in the ElastiCache module
resource "aws_secretsmanager_secret_version" "valkey_auth" {
  secret_id     = aws_secretsmanager_secret.valkey_auth.id
  secret_string = random_password.valkey_auth.result
}

# =============================================================================
