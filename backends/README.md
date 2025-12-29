# Backend Options for Terraform State Storage

This directory contains different backend configurations for storing Terraform state files.

## 🚀 Usage (Recommended method)

### Default backend (Local)
```bash
terraform init
```

### Switch backends
```bash
# OVH Object Storage
terraform init -backend-config=backends/ovh-backend.hcl

# Terraform Cloud
terraform init -backend-config=backends/terraform-cloud.hcl

# AWS S3
terraform init -backend-config=backends/aws-s3.hcl
```

## 📁 Available configuration files

### Backend Configuration Files (.hcl)
- **`ovh-backend.hcl`** - OVH Object Storage configuration
- **`terraform-cloud.hcl`** - Terraform Cloud configuration
- **`aws-s3.hcl`** - AWS S3 configuration

### Backend Examples (.tf)
- **`ovh-object-storage.tf`** - Complete OVH Object Storage example
- **`terraform-cloud.tf`** - Terraform Cloud example
- **`aws-s3.tf`** - AWS S3 example
- **`azure-blob.tf`** - Azure Blob Storage example
- **`gcs.tf`** - Google Cloud Storage example
- **`local.tf`** - Local storage example

## 🎯 Available Backends

### 1. **Local Storage** (Default)
- **File**: Default backend in `versions.tf`
- **Use case**: Development and testing only
- **Command**: `terraform init`

### 2. **OVH Object Storage**
- **File**: `ovh-backend.hcl`
- **Use case**: OVH ecosystem, backup automation
- **Command**: `terraform init -backend-config=backends/ovh-backend.hcl`

### 3. **Terraform Cloud** (HashiCorp Cloud)
- **File**: `terraform-cloud.hcl`
- **Use case**: Managed service with collaboration
- **Command**: `terraform init -backend-config=backends/terraform-cloud.hcl`

### 4. **AWS S3**
- **File**: `aws-s3.hcl`
- **Use case**: AWS ecosystem with DynamoDB locking
- **Command**: `terraform init -backend-config=backends/aws-s3.hcl`

## 🔄 Migration between backends

To migrate from one backend to another:

1. **Backup current state** (optional but recommended):
   ```bash
   cp terraform.tfstate terraform.tfstate.backup
   ```

2. **Change backend**:
   ```bash
   terraform init -backend-config=backends/new-backend.hcl
   ```

3. **Confirm migration**: Terraform will offer to migrate existing state

## 🔧 Required variables

Add these variables in your `terraform.tfvars`:

### For OVH Object Storage
```hcl
ovh_access_key = "your_access_key_s3"
ovh_secret_key = "your_secret_key_s3"
```

### For Terraform Cloud
```hcl
# Configure via environment variable:
# export TF_TOKEN_app_terraform_io="your_token"
```

### For AWS S3
```hcl
aws_access_key = "your_access_key"
aws_secret_key = "your_secret_key"
```

## 🎯 Recommendations

- **Development**: Local backend (default)
- **Personal use**: OVH Object Storage (stay in OVH ecosystem)
- **Team/Production**: Terraform Cloud (best collaboration features)
- **Cloud-specific**: Choose backend matching your primary cloud provider
