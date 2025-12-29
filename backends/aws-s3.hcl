# Backend Configuration File pour AWS S3
# Utilisé avec : terraform init -backend-config=aws-s3.hcl

backend = {
  bucket         = "terraform-state-netarchitect"
  key            = "dns-infra/terraform.tfstate"
  region         = "us-east-1"
  encrypt        = true
  dynamodb_table = "terraform-locks"
}
