# Backend Configuration File pour Terraform Cloud
# Utilisé avec : terraform init -backend-config=terraform-cloud.hcl

backend = {
  organization = "netarchitect"
  workspaces = {
    name = "dns-infrastructure"
  }
}
