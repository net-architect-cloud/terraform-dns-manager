# Terraform DNS Manager - Multi-Provider Template

[![CI Status](https://github.com/Net-Architect-Cloud/terraform-dns-manager/workflows/DNS%20Infrastructure%20CI/badge.svg)](https://github.com/Net-Architect-Cloud/terraform-dns-manager/actions)
[![GitHub forks](https://img.shields.io/github/forks/Net-Architect-Cloud/terraform-dns-manager?style=flat&logo=github)](https://github.com/Net-Architect-Cloud/terraform-dns-manager/network/members)
[![Terraform](https://img.shields.io/badge/Terraform-1.7+-623CE4?style=flat&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Cloudflare](https://img.shields.io/badge/Cloudflare-5.11+-F38020?style=flat&logo=cloudflare&logoColor=white)](https://registry.terraform.io/providers/cloudflare/cloudflare/latest)
[![OVH](https://img.shields.io/badge/OVH-2.0+-0055A4?style=flat&logo=ovh&logoColor=white)](https://registry.terraform.io/providers/ovh/ovh/latest)
[![Infomaniak](https://img.shields.io/badge/Infomaniak-1.3.6+-FF6600?style=flat&logo=infomaniak&logoColor=white)](https://registry.terraform.io/providers/Infomaniak/infomaniak/latest)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A comprehensive Terraform template for managing DNS records across multiple domains using multiple DNS providers with flexible backend storage options.

## 🏗️ Architecture

- **Providers**: Cloudflare DNS (v5.11+), OVH DNS (v2.0+), and Infomaniak DNS (v1.3.6)
- **State Backend**: Multiple options - Local (default), Terraform Cloud, OVH Object Storage, AWS S3
- **CI/CD**: GitHub Actions with dynamic backend selection
- **Structure**: Modular approach with separate zones per provider
- **Language**: All comments and documentation in English

## 📁 Project Structure

```
.
├── main.tf                    # Main configuration calling zone modules
├── versions.tf                # Terraform and provider version constraints
├── providers.tf               # Multi-provider configuration with variables
├── zones/                     # DNS zones organized by provider
│   ├── example-cloudflare.com/
│   │   └── records.tf         # DNS records for Cloudflare domain
│   ├── example-ovh.com/
│   │   └── records.tf         # DNS records for OVH domain
│   └── example-infomaniak.com/
│       └── records.tf         # DNS records for Infomaniak domain
├── .github/workflows/
│   └── terraform.yml         # CI/CD pipeline with backend selection
└── .env.example              # Environment variables template
```

## 🚀 Getting Started

### Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.7.0
- Cloudflare account with API token (optional)
- OVH account with API credentials (optional)
- Infomaniak account with API token (optional)
- Cloud storage backend (optional, for production use)

### Local Development Setup

1. **Clone the repository**
   ```bash
   git clone <your-repository-url>
   cd terraform-dns-manager
   ```

2. **Configure environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your actual values
   ```

3. **Required environment variables**
   ```bash
   # Cloudflare (optional)
   export CLOUDFLARE_API_TOKEN="your_cloudflare_api_token"
   
   # OVH (optional)
   export OVH_APPLICATION_KEY="your_ovh_application_key"
   export OVH_APPLICATION_SECRET="your_ovh_application_secret"
   export OVH_CONSUMER_KEY="your_ovh_consumer_key"
   export OVH_ENDPOINT="ovh-eu"
   
   # Infomaniak (optional)
   export INFOMANIAK_TOKEN="your_infomaniak_api_token"
   
   # Backend storage (optional, required for non-local backends)
   export AWS_ACCESS_KEY_ID="your_storage_access_key"
   export AWS_SECRET_ACCESS_KEY="your_storage_secret_key"
   export TF_TOKEN_app_terraform_io="your_terraform_cloud_token"
   ```

4. **Update configuration**
   - Modify zone directories under `zones/` to match your domains
   - For production, consider switching to a remote backend

5. **Initialize Terraform**
   ```bash
   terraform init
   ```

6. **Plan changes**
   ```bash
   terraform plan
   ```

7. **Apply changes**
   ```bash
   terraform apply
   ```

## 🔧 Configuration

### Cloudflare API Token

Your Cloudflare API token needs the following permissions:
- `Zone:DNS:Edit` - To manage DNS records
- `Zone:Zone:Read` - To read zone information

### OVH API Credentials

To use OVH as DNS provider, you need to create API credentials:

1. Go to [OVH API Console](https://api.ovh.com/createToken/)
2. Create an application to get Application Key and Secret
3. Generate consumer keys with the following permissions:
   - `/domain/zone/*` - Full access to DNS zones
   - `/me/*` - Read access to account information

4. Choose your endpoint based on your OVH region:
   - `ovh-eu` - Europe
   - `ovh-ca` - Canada
   - `ovh-us` - United States

### Infomaniak API Token

To use Infomaniak as DNS provider, you need to create an API token:

1. Log in to your [Infomaniak Manager](https://manager.infomaniak.com)
2. Go to API section or Developer tools
3. Create a new API token with DNS management permissions
4. The token should have access to domain management functions

### State Backend Configuration

The Terraform state is stored using various backend options. The default is local storage for development, but multiple backends are available directly in `versions.tf`:

#### Available Backends

1. **Local Storage** (Default) - Development and testing only
2. **Terraform Cloud** (HashiCorp Cloud) - Managed service with collaboration features
3. **Cloudflare R2** - Cost-effective, S3-compatible storage with Cloudflare ecosystem
4. **OVH Object Storage** - OVH ecosystem integration
5. **AWS S3** - AWS ecosystem integration with DynamoDB locking
6. **Azure Blob Storage** - Azure ecosystem integration
7. **Google Cloud Storage** - GCP ecosystem integration

#### Switching Backends

To switch backends, edit `versions.tf` and:

1. **Comment the default backend**:
   ```hcl
   # backend "local" {
   #   path = "./terraform.tfstate"
   # }
   ```

2. **Uncomment your desired backend**:
   ```hcl
   # Example for Cloudflare R2
   backend "s3" {
     bucket = "terraform-state"
     key    = "terraform.tfstate"
     region = "auto"
     endpoint = "https://<account-id>.r2.cloudflarestorage.com"
     skip_credentials_validation = true
     skip_region_validation      = true
     skip_requesting_account_id  = true
     skip_metadata_api_check     = true
   }
   ```

3. **Configure required environment variables**
4. **Run `terraform init`** to migrate the state

#### Backend-Specific Configuration

**Cloudflare R2:**
- Required variables: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`
- Replace `<account-id>` with your Cloudflare account ID
- Create R2 bucket in Cloudflare Dashboard first

**Terraform Cloud:**
- Required variables: `TF_TOKEN_app_terraform_io`
- Update `organization` and `workspaces.name` values

**OVH Object Storage:**
- Required variables: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`
- Uses OVH S3-compatible endpoint

**AWS S3:**
- Required variables: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`
- Supports DynamoDB locking for state consistency

## 🏃‍♂️ CI/CD Pipeline

The GitHub Actions workflow (`.github/workflows/terraform.yml`) automatically:

- **On Pull Requests**: Runs `terraform plan` and uploads the plan as an artifact
- **On Main Branch**: Runs `terraform apply` to deploy changes
- **Multi-Provider Support**: Works with Cloudflare, OVH, and Infomaniak
- **Backend Configuration**: Uses backend configured in `versions.tf`

### Required GitHub Secrets

Configure these secrets in your GitHub repository:

**Cloudflare (optional)**:
- `CLOUDFLARE_API_TOKEN`: Your Cloudflare API token

**OVH (optional)**:
- `OVH_APPLICATION_KEY`: Your OVH application key
- `OVH_APPLICATION_SECRET`: Your OVH application secret
- `OVH_CONSUMER_KEY`: Your OVH consumer key

**Infomaniak (optional)**:
- `INFOMANIAK_TOKEN`: Your Infomaniak API token

**Backend Storage (optional)**:
- `TF_TOKEN_app_terraform_io`: Terraform Cloud API token
- `AWS_ACCESS_KEY_ID`: Storage access key (R2, S3, OVH)
- `AWS_SECRET_ACCESS_KEY`: Storage secret key (R2, S3, OVH)
- `ARM_CLIENT_ID`: Azure service principal client ID
- `ARM_CLIENT_SECRET`: Azure service principal client secret
- `ARM_SUBSCRIPTION_ID`: Azure subscription ID
- `ARM_TENANT_ID`: Azure tenant ID
- `GOOGLE_APPLICATION_CREDENTIALS`: Path to GCP service account JSON file

### Enabling CI/CD

The CI/CD pipeline is disabled by default to prevent failures. To enable it:

1. Configure all required GitHub secrets (see above)
2. Update your configuration files (zones, backend in `versions.tf`, etc.)
3. Edit `.github/workflows/terraform.yml`:
   - Uncomment the `on:` triggers section
   - Remove or comment the `workflow_dispatch:` trigger
4. Test with a manual workflow dispatch first

## 📝 Managing DNS Records

### Adding a New Zone

**For Cloudflare zones:**
1. Create a new directory under `zones/`
2. Copy the `zones/example.com/` structure
3. Update `records.tf` with your DNS records
4. Update `main.tf` to include the new module with cloudflare provider
5. Test locally and create a pull request

**For Infomaniak zones:**
1. Create a new directory under `zones/`
2. Copy the `zones/example-infomaniak.com/` structure
3. Update `records.tf` with your DNS records
4. Update `main.tf` to include the new module with infomaniak provider
5. Test locally and create a pull request

### Supported Record Types

- **A Records**: IPv4 addresses
- **AAAA Records**: IPv6 addresses
- **CNAME Records**: Canonical name records
- **MX Records**: Mail exchange records
- **TXT Records**: Text records (SPF, DKIM, DMARC)
- **SRV Records**: Service records

### Example Record Configurations

**Cloudflare Records:**
```hcl
# A Record (subdomain)
resource "cloudflare_dns_record" "example_a" {
  zone_id = data.cloudflare_zone.this.zone_id
  name    = "subdomain"
  type    = "A"
  content = "192.168.1.1"
  ttl     = 3600
  proxied = false
}

# CNAME Record (subdomain)
resource "cloudflare_dns_record" "example_cname" {
  zone_id = data.cloudflare_zone.this.zone_id
  name    = "www"
  type    = "CNAME"
  content = "example.com."
  ttl     = 1
  proxied = true
}
```

**Infomaniak Records:**
```hcl
# A Record (subdomain)
resource "infomaniak_record" "example_a" {
  zone_fqdn = "example-infomaniak.com"
  type        = "A"
  source      = "192.168.1.1"
  ttl         = 3600
}

# CNAME Record (subdomain)
resource "infomaniak_record" "example_cname" {
  zone_fqdn = "example-infomaniak.com"
  type        = "CNAME"
  source      = "www"
  target      = "example.com."
  ttl         = 3600
}

# MX Record
resource "infomaniak_record" "example_mx" {
  zone_fqdn = "example-infomaniak.com"
  type        = "MX"
  source      = "@"
  data = {
    priority = 10
    target   = "mail.example.com."
  }
  ttl         = 3600
}

# CAA Record
resource "infomaniak_record" "example_caa" {
  zone_fqdn = "example-infomaniak.com"
  type        = "CAA"
  source      = "0 issue \"letsencrypt.org\""
  ttl         = 3600
}

# SRV Record (using data field)
resource "infomaniak_record" "example_srv" {
  zone_fqdn = "example-infomaniak.com"
  type        = "SRV"
  source      = "_service._tcp"
  data = {
    priority = 10
    weight   = 5
    port     = 443
    target   = "target.example.com."
  }
  ttl         = 3600
}
```

## 🔒 Security Best Practices

- API tokens are stored as GitHub secrets
- State file is encrypted in cloud storage backends
- No sensitive data in repository
- Regular security updates via Dependabot
- Use least privilege principle for API tokens

## 🐛 Troubleshooting

### Common Issues

1. **Provider version conflicts**: Run `terraform init -upgrade`
2. **State lock issues**: Check backend storage permissions
3. **API rate limits**: Wait and retry, or check token permissions
4. **OVH zone refresh**: OVH applies changes automatically
5. **Infomaniak record syntax**: Use `source` field for simple records, `data` field for complex ones
6. **Backend switching**: Edit `versions.tf` to change backend, then run `terraform init`
7. **Cloudflare R2 configuration**: Ensure correct account ID and R2 bucket exists

### Useful Commands

```bash
# Check current state
terraform show

# Import existing DNS record (Cloudflare)
terraform import module.zone_name.cloudflare_dns_record.record_name zone_id/record_id

# Import existing DNS record (OVH)
terraform import module.zone_name.ovh_domain_zone_record.record_name zone_name/record_id

# Import existing DNS record (Infomaniak)
terraform import module.zone_name.infomaniak_record.record_name zone_fqdn/record_id

# Refresh state
terraform refresh

# Validate configuration
terraform validate

# Switch backends (edit versions.tf first)
terraform init

# Format code
terraform fmt
```

### Provider-Specific Notes

**Cloudflare:**
- Supports proxying with `proxied = true`
- Uses `zone_id` from data source
- TTL of 1 enables automatic TTL optimization

**OVH:**
- Changes are applied automatically (no manual refresh needed)
- Uses `zone` name and `fieldtype` for records
- Supports all standard DNS record types

**Infomaniak:**
- Uses `zone_fqdn` instead of zone ID
- Requires `source` field for all records
- Use `data` field for complex records (MX, SRV, SSHFP)
- Use `target` field for CNAME and similar records

## 📚 Documentation

- [Terraform Cloudflare Provider](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs)
- [Terraform OVH Provider](https://registry.terraform.io/providers/ovh/ovh/latest/docs)
- [Terraform Infomaniak Provider](https://registry.terraform.io/providers/infomaniak/infomaniak/latest/docs)
- [Cloudflare API Documentation](https://developers.cloudflare.com/api/)
- [OVH API Documentation](https://docs.ovh.com/gb/en/api/)
- [Infomaniak API Documentation](https://api.infomaniak.com/docs)
- [Terraform Backend Configuration](https://www.terraform.io/docs/language/settings/backends/s3.html)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test locally
5. Create a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👨‍💻 Author

**Net Architect**

- 🌐 Website: [netarchitect.cloud](https://netarchitect.cloud)
- 📧 Email: [contact@netarchitect.cloud](mailto:contact@netarch.cloud)
- 🐙 GitHub: [@Net-Architect-Cloud](https://github.com/Net-Architect-Cloud)
- 💼 LinkedIn: [Net Architect](https://ch.linkedin.com/in/kevin-allioli)

---

*Built with ❤️ by Net Architect - Making infrastructure management simple and reliable.*
