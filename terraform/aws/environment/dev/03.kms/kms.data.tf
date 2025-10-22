# =============================================================================
# terraform_integration_templates :: environment/dev/03.kms/kms.data.tf
#      :: mdunbar :: 2025 oct 10 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
# AWS Account info
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "service_principals" {
  statement {
    sid = "AllowAWSServiceUsage"
    principals {
      type        = "Service"
      identifiers = [
        "s3.amazonaws.com",
        "dynamodb.amazonaws.com",
      ]
    }

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
    ]

    resources = ["*"]
  }
}

# ----------------------------------------------------------------------------

# outputs.tf
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

# =============================================================================
