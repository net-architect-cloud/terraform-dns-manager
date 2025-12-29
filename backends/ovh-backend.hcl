# Backend Configuration File
# Utilisé avec : terraform init -backend-config=backend.hcl

backend = {
  bucket         = "terraform-state-netarchitect"
  key            = "dns-infra/terraform.tfstate"
  region         = "GRA"
  endpoint       = "s3.gra.io.cloud.ovh.net"
  encrypt        = true
  skip_credentials_validation = true
  skip_region_validation      = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
}
