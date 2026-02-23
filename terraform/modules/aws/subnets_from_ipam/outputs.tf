# =============================================================================
# terraform_integration_templates :: terraform/modules/aws/eks_subnet/outputs.tf
#       :: mdunbar :: 2026 Feb 21 :: MIT License © 2026 Matthew Dunbar ::
# =============================================================================
output "private_subnet_ids" {
  description = "List of private subnet IDs for EKS"
  value       = values(aws_subnet.private)[*].id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs for EKS"
  value       = values(aws_subnet.public)[*].id
}

# =============================================================================
