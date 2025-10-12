terraform {
  required_version = ">= 1.7.0"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.11"
    }
  }

  backend "s3" {
    bucket = "your-terraform-state-bucket"  # Replace with your R2 bucket name
    key    = "dns-infra/terraform.tfstate"
    endpoints = {
      s3 = "https://YOUR_ACCOUNT_ID.r2.cloudflarestorage.com"  # Replace with your Account ID
    }
    region = "us-east-1"
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_s3_checksum            = true
  }
}