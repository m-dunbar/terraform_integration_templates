# =============================================================================
# terraform_integration_templates :: environment/dev/02.iam/iam.locals.tf
#      :: mdunbar :: 2025 oct 05 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
locals {
  # While often ordering values alphabetically improves maintainability
  # in this case, conceptual order has better readability and is easier to follow.
  # -----------------------------------------------------------------
  # Curated values
  # -------------------------
  environment  = "dev"  # the functional environment name (dev, staging, prod, etc)
  account_alias_prefix = "tf-integration-templates"  # prefix for AWS account alias
  
  # Choose ONE LOGICAL APPROACH for account_id (comment out the other): 
  #  declare account_id here explicitly (MUCH safer) 
  # - OR -
  #  derive it (below) from the ENV variable AWS_PROFILE (more portable, but also riskier)
  #  BE EXTREMELY CAREFUL which AWS_PROFILE is active if using the derived approach!
  #
  #  While we have only a single AWS Account in use for our examples, the dynamic example is illustrated.
  #  This allows an easy way to deploy the sample terraform by adding a supporting 
  #  profile definition in ~/.aws/config and ~/.aws/credentials, then exporting AWS_PROFILE=that-profile-name

  # Examples (while it should go without saying, set only one value):
  # account_id   = "000000000000"    # localstack account id
  # account_id   = "123456789012"    # hardcoded account id

  # -----------------------------------------------------------------
  # Derived values
  # -------------------------
  account_name = "${local.account_alias_prefix}-${local.environment}" # human-friendly AWS account name
  account_id   = data.aws_caller_identity.current.account_id          # example of dynamic lookup approach

  # SAML Provider ARN
  saml_provider_id = [ "arn:aws:iam::${local.account_id}:saml-provider/auth0_saml_provider" ]

  # IAM Role Trust Policy Statement
  assume_role_statement = [
    {
      actions = ["sts:AssumeRole"]
      principals = [
        {
          type        = "AWS"
          identifiers = ["arn:aws:iam::${local.account_id}:role/auth0_saml_provider"]
        }
      ]
    }
  ]
}

# =============================================================================
