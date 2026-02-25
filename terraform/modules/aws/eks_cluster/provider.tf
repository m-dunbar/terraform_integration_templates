# =============================================================================
# terraform_integration_templates :: terraform/modules/aws/subnets_from_ipam/provider.tf
#       :: mdunbar :: 2026 Feb 21 :: MIT License © 2026 Matthew Dunbar ::
# =============================================================================

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.1"
    }
    kubernetes = { 
      source = "hashicorp/kubernetes" 
      version = "~> 2.38"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "helm" {
  kubernetes = {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

provider "kubernetes" {
  host = data.aws_eks_cluster.this.endpoint

  cluster_ca_certificate = base64decode(
    data.aws_eks_cluster.this.certificate_authority[0].data
  )

  token = data.aws_eks_cluster_auth.this.token
}

# =============================================================================
