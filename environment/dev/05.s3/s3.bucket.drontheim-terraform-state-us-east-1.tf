# =============================================================================
# terraform-integration-template :: s3.bucket.tf-integration-template-terraform-state-us-east-1.tf :: mdunbar :: 2025 oct 05
# =============================================================================
resource "aws_s3_bucket" "drontheim_terraform_state_us_east_1" {
  bucket = "tf-integration-template-terraform-state-us-east-1"

  tags = {
    Name        = "tf-integration-template-terraform-state-us-east-1"
    Environment = "Production"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "drontheim_terraform_state_us_east_1" {
  bucket = aws_s3_bucket.drontheim_terraform_state_us_east_1.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = "alias/terraform-state-key"
    }
  }
}

resource "aws_s3_bucket_versioning" "drontheim_terraform_state_us_east_1" {
  bucket = aws_s3_bucket.drontheim_terraform_state_us_east_1.id
  versioning_configuration {
    status = "Enabled"
  }
}

# =============================================================================