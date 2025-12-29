# Backend Options for Terraform State Storage

Ce dossier contient différentes configurations de backend pour stocker les fichiers d'état Terraform.

## 🚀 Utilisation (Nouvelle méthode recommandée)

### Backend par défaut (Local)
```bash
terraform init
```

### Changer de backend
```bash
# OVH Object Storage
terraform init -backend-config=backends/ovh-backend.hcl

# Terraform Cloud
terraform init -backend-config=backends/terraform-cloud.hcl

# AWS S3
terraform init -backend-config=backends/aws-s3.hcl
```

## 📁 Fichiers de configuration disponibles

### Backend Configuration Files (.hcl)
- **`ovh-backend.hcl`** - Configuration OVH Object Storage
- **`terraform-cloud.hcl`** - Configuration Terraform Cloud
- **`aws-s3.hcl`** - Configuration AWS S3

### Backend Examples (.tf)
- **`ovh-object-storage.tf`** - Exemple complet OVH Object Storage
- **`terraform-cloud.tf`** - Exemple Terraform Cloud
- **`aws-s3.tf`** - Exemple AWS S3
- **`azure-blob.tf`** - Exemple Azure Blob Storage
- **`gcs.tf`** - Exemple Google Cloud Storage
- **`local.tf`** - Exemple Local Storage

## 🎯 Available Backends

### 1. **Local Storage** (Default)
- **File**: Backend par défaut dans `versions.tf`
- **Use case**: Développement et testing uniquement
- **Command**: `terraform init`

### 2. **OVH Object Storage**
- **File**: `ovh-backend.hcl`
- **Use case**: Écosystème OVH, backup automatique
- **Command**: `terraform init -backend-config=backends/ovh-backend.hcl`

### 3. **Terraform Cloud** (HashiCorp Cloud)
- **File**: `terraform-cloud.hcl`
- **Use case**: Service géré avec collaboration
- **Command**: `terraform init -backend-config=backends/terraform-cloud.hcl`

### 4. **AWS S3**
- **File**: `aws-s3.hcl`
- **Use case**: Écosystème AWS avec locking DynamoDB
- **Command**: `terraform init -backend-config=backends/aws-s3.hcl`

## 🔄 Migration entre backends

Pour migrer d'un backend à un autre :

1. **Backup actuel** (optionnel mais recommandé) :
   ```bash
   cp terraform.tfstate terraform.tfstate.backup
   ```

2. **Changer de backend** :
   ```bash
   terraform init -backend-config=backends/nouveau-backend.hcl
   ```

3. **Confirmer la migration** : Terraform vous proposera de migrer l'état existant

## 🔧 Variables requises

Ajoutez ces variables dans votre `terraform.tfvars` :

### Pour OVH Object Storage
```hcl
ovh_access_key = "votre_access_key_s3"
ovh_secret_key = "votre_secret_key_s3"
```

### Pour Terraform Cloud
```hcl
# Configurez via variable d'environnement :
# export TF_TOKEN_app_terraform_io="votre_token"
```

### Pour AWS S3
```hcl
aws_access_key = "votre_access_key"
aws_secret_key = "votre_secret_key"
```

## 🎯 Recommandations

- **Développement**: Local backend (par défaut)
- **Usage personnel**: OVH Object Storage (reste dans écosystème OVH)
- **Équipe/Production**: Terraform Cloud (meilleures fonctionnalités collaboratives)
- **Écosystème cloud**: Choisissez le backend correspondant à votre provider principal
