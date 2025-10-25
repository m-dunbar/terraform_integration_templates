# =============================================================================
# terraform_integration_templates :: terraform/aws/environment/dev/07.vpc/vpc.outputs.tf
#       :: mdunbar :: 2025 Oct 25 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
output "vpc_id" {
  value = module.vpc_dev.vpc_id
}

output "private_subnets" {
  value = module.vpc_dev.private_subnets
}

output "public_subnets" {
  value = module.vpc_dev.public_subnets
}

# =============================================================================
