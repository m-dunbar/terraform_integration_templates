# =============================================================================
# terraform_integration_templates :: terraform/aws/environment/dev/09.elasticache/elasticache.data.tf
#       :: mdunbar :: 2025 Dec 01 :: MIT License © 2025 Matthew Dunbar ::
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

data "aws_vpc" "dev_vpc" {
  id = data.terraform_remote_state.vpc.outputs.vpc_id
} 

# =============================================================================
