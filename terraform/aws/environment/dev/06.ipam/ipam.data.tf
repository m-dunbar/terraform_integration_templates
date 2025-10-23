# =============================================================================
# terraform_integration_templates :: terraform/aws/environment/dev/06.ipam/ipam.data.tf
#       :: mdunbar :: 2025 Oct 22 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
# AWS Account info
data "aws_caller_identity" "current" {}

# =============================================================================
