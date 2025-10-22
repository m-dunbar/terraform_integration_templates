# =============================================================================
# terraform-integration-template :: s3.bucket.tf-integration-template-terraform-state-us-east-1.tf :: mdunbar :: 2025 oct 05
# =============================================================================
resource "aws_s3_bucket" "tf_integration_template_terraform_state_us_east_1" {
  bucket = "tf-integration-template-terraform-state-us-east-1"

  tags = {
    Name        = "tf-integration-template-terraform-state-us-east-1"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf_integration_template_terraform_state_us_east_1" {
  bucket = aws_s3_bucket.tf_integration_template_terraform_state_us_east_1.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = data.aws_kms_key.terraform.arn
    }
  }
}

resource "aws_s3_bucket_versioning" "tf_integration_template_terraform_state_us_east_1" {
  bucket = aws_s3_bucket.tf_integration_template_terraform_state_us_east_1.id
  versioning_configuration {
    status = "Enabled"
  }
}

# =============================================================================
