# =============================================================================
# terraform_integration_templates :: terraform/aws/environment/dev/09.elasticache/elasticache.locals.tf
#       :: mdunbar :: 2025 Dec 01 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
locals {
  environment = "dev"
  name        = "tf-integration-valkey-replication-group"
  tags        = {
    Environment = local.environment
    ManagedBy   = "Terraform"
  }
}

# =============================================================================
