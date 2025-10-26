# =============================================================================
# terraform_integration_templates :: terraform/aws/environment/dev/08.rds/rds.data.tf
#       :: mdunbar :: 2025 Oct 24 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
# AWS Account info
data "aws_caller_identity" "current" {}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "tf-integration-template-terraform-state-us-east-1"
    key    = "vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

# =============================================================================
