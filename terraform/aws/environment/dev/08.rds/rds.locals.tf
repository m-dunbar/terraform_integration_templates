# =============================================================================
# terraform_integration_templates :: terraform/aws/environment/dev/08.rds/rds.locals.tf
#       :: mdunbar :: 2025 Oct 24 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
locals {
  environment = "dev"
  region      = "us-east-1"

  # lambda_dir      = "lambda/SecretsManagerRDSMySQLRotationSingleUser"
  # lambda_bucket   = "rds-pswd-rotation-${local.region}"
  # lambda_function = "lambda_function.py"
  # lambda_zip      = "SecretsManagerRDSMySQLRotationSingleUser.zip"
  # lambda_key      = "lambda/${local.lambda_zip}"
}

# =============================================================================
