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
  # To use another backend, use: terraform init -backend-config=backends/<name>.hcl
  backend "local" {
    path = "./terraform.tfstate"
  }

  # Alternative Backends (use with -backend-config) :
  # terraform init -backend-config=backends/ovh-backend.hcl      # OVH Object Storage
  # terraform init -backend-config=backends/terraform-cloud.hcl   # Terraform Cloud
  # terraform init -backend-config=backends/aws-s3.hcl           # AWS S3
  # terraform init -backend-config=backends/azure-blob.hcl       # Azure Blob Storage
  # terraform init -backend-config=backends/gcs.hcl              # Google Cloud Storage
}