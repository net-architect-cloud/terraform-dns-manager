terraform {
  required_version = ">= 1.7.0"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.11"
    }
    ovh = {
      source  = "ovh/ovh"
      version = "~> 2.0"
    }
    infomaniak = {
      source  = "Infomaniak/infomaniak"
      version = "1.3.6"
    }
  }

  # Backend Configuration - Local Storage (Default)
  # Uncomment the backend you want to use and comment the others

  # 1. Local Storage (Default - Development)
  backend "local" {
    path = "./terraform.tfstate"
  }

  # 2. Terraform Cloud (Production/Team)
  # backend "remote" {
  #   hostname = "app.terraform.io"
  #   organization = "your-organization"
  #   workspaces {
  #     name = "dns-manager"
  #   }
  # }

  # 3. Cloudflare R2 (Cloudflare Ecosystem)
  # backend "s3" {
  #   bucket = "terraform-state"
  #   key    = "terraform.tfstate"
  #   region = "auto"
  #   endpoint = "https://<account-id>.r2.cloudflarestorage.com"
  #   skip_credentials_validation = true
  #   skip_region_validation      = true
  #   skip_requesting_account_id  = true
  #   skip_metadata_api_check     = true
  # }

  # 4. OVH Object Storage (OVH Ecosystem)
  # backend "s3" {
  #   bucket = "terraform-state"
  #   key    = "terraform.tfstate"
  #   region = "GRA"
  #   endpoint = "s3.gra.io.cloud.ovh.us"
  #   skip_credentials_validation = true
  #   skip_region_validation      = true
  #   skip_requesting_account_id  = true
  #   skip_metadata_api_check     = true
  # }

  # 5. AWS S3 (AWS Ecosystem)
  # backend "s3" {
  #   bucket         = "your-bucket"
  #   key            = "terraform.tfstate"
  #   region         = "your-region"
  #   encrypt        = true
  #   dynamodb_table = "terraform-locks"
  # }

  # 6. Azure Blob Storage
  # backend "azurerm" {
  #   resource_group_name  = "terraform-rg"
  #   storage_account_name = "terraformstate"
  #   container_name       = "tfstate"
  #   key                  = "terraform.tfstate"
  # }

  # 7. Google Cloud Storage
  # backend "gcs" {
  #   bucket = "your-bucket"
  #   prefix = "terraform.tfstate"
  # }
}