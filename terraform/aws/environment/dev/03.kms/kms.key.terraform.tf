# =============================================================================
# terraform_integration_templates :: environment/dev/03.kms/kms.key.tf
#       :: mdunbar :: 2025 Oct 10 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
module "kms" {
  source = "terraform-aws-modules/kms/aws"

  description             = "Terraform KMS Key"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  is_enabled              = true
  key_usage               = "ENCRYPT_DECRYPT"
  multi_region            = true

  # Policy
  enable_default_policy = false
  policy = data.aws_iam_policy_document.terraform_key_policy.json

  # Aliases
  computed_aliases = {
    alias = { 
      name = "terraform"
    }
  }

  tags = {
    Environment = var.environment
    Managed_by  = "Terraform"
  }
}

data "aws_iam_policy_document" "terraform_key_policy" {
  statement {
    sid = "AllowRootAccountFullAccess"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }

  statement {
    sid = "AllowKeyAdministrators"
    principals {
      type        = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/Administrators"
      ]
    }
    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:RotateKeyOnDemand"
    ]
    resources = ["*"]
  }

  statement {
    sid = "AllowKeyUsers"
    principals {
      type        = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/terraform-provisioner",
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/Developers"
      ]
    }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]
  }

  statement {
    sid = "AllowAWSServiceUsage"
    principals {
      type        = "Service"
      identifiers = [
        "s3.amazonaws.com",
        "dynamodb.amazonaws.com"
      ]
    }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]
  }

  statement {
    sid = "AllowKeyUsersCreateGrantsForServices"
    principals {
      type        = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/terraform-provisioner",
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/Administrators",
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/Developers"

      ]
    }
    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values   = ["true"]
    }
    actions = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant"
    ]
    resources = ["*"]
  }
}
# =============================================================================
