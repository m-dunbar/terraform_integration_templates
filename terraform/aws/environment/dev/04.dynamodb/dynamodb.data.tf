# =============================================================================
# terraform_integration_templates :: environment/dev/04.dynamodb/dynamodb.data.tf
#      :: mdunbar :: 2025 oct 10 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
# AWS Account info
data "aws_caller_identity" "current" {}

data "aws_kms_key" "terraform" {
  count = var.bootstrap_plan ? 0 : 1  
  key_id = "alias/terraform"
}

locals {
  terraform_kms_key_arn = (
    var.bootstrap_plan
    ? "bootstrap planning: kms key not yet created"
    : try(data.aws_kms_key.terraform[0].arn, "kms key with alias/terraform not found")
    )
}

# outputs.tf
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "terraform_kms_key" {
  value = local.terraform_kms_key_arn
}

# =============================================================================
