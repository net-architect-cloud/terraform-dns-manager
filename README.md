# Terraform DNS Manager for Cloudflare - Template

[![CI Status](https://github.com/Net-Architect-Cloud/terraform-dns-manager-for-cloudflare/workflows/DNS%20Infrastructure%20CI/badge.svg)](https://github.com/Net-Architect-Cloud/terraform-dns-manager-for-cloudflare/actions)
[![GitHub forks](https://img.shields.io/github/forks/Net-Architect-Cloud/terraform-dns-manager-for-cloudflare?style=flat&logo=github)](https://github.com/Net-Architect-Cloud/terraform-dns-manager-for-cloudflare/network/members)
[![Terraform](https://img.shields.io/badge/Terraform-1.7+-623CE4?style=flat&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Cloudflare](https://img.shields.io/badge/Cloudflare-5.11+-F38020?style=flat&logo=cloudflare&logoColor=white)](https://registry.terraform.io/providers/cloudflare/cloudflare/latest)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A Terraform template for managing DNS records across multiple domains using multiple DNS providers.

## 🏗️ Architecture

- **Providers**: Cloudflare DNS (v5.11+), OVH DNS (v2.0+), and Infomaniak DNS (v2.0+)
- **State Backend**: Cloudflare R2 Object Storage
- **CI/CD**: GitHub Actions
- **Structure**: Modular approach with separate zones

## 📁 Project Structure

```
.
├── main.tf                    # Main configuration calling zone modules
├── versions.tf                # Terraform and provider version constraints
├── providers.tf               # Cloudflare, OVH, and Infomaniak providers configuration
├── zones/                     # DNS zones organized by domain
│   ├── example.com/
│   │   ├── records.tf         # DNS records for example.com
│   │   └── versions.tf        # Zone-specific provider requirements
│   ├── example-ovh.com/
│   │   ├── records.tf         # DNS records for OVH domain
│   │   └── versions.tf        # Zone-specific provider requirements
│   └── example-infomaniak.com/
│       ├── records.tf         # DNS records for Infomaniak domain
│       └── versions.tf        # Zone-specific provider requirements
└── .github/workflows/
    └── terraform.yml         # CI/CD pipeline
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
   cd dns-infrastructure
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
   export AWS_ACCESS_KEY_ID="your_r2_access_key"
   export AWS_SECRET_ACCESS_KEY="your_r2_secret_key"
   export AWS_EC2_METADATA_DISABLED=true
   ```

4. **Update configuration**
   - Modify `zones/example.com/` to match your domain
   - For production, consider switching to a remote backend (see backends/README.md)

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

The Terraform state is stored using various backend options. The default is local storage for development, but multiple backends are supported:

#### Available Backends

1. **Local Storage** (Default) - Development and testing only
2. **Cloudflare R2** - Cost-effective, S3-compatible storage
3. **Terraform Cloud** (HashiCorp Cloud) - Managed service with collaboration features
4. **AWS S3** - AWS ecosystem integration with DynamoDB locking
5. **Azure Blob Storage** - Azure ecosystem integration
6. **Google Cloud Storage** - GCP ecosystem integration

#### Switching Backends

1. Choose a backend configuration from `./backends/` directory
2. Replace the backend block in `versions.tf`
3. Configure required environment variables
4. Run `terraform init` to migrate the state

#### Default Local Backend Configuration

```hcl
backend "local" {
  path = "./terraform.tfstate"
}
```

For detailed backend documentation, see `./backends/README.md`

## 🏃‍♂️ CI/CD Pipeline

The GitHub Actions workflow (`.github/workflows/terraform.yml`) automatically:

- **On Pull Requests**: Runs `terraform plan` and uploads the plan as an artifact
- **On Main Branch**: Runs `terraform apply` to deploy changes
- **Daily**: Runs drift detection to check for manual changes

### Required GitHub Secrets

Configure these secrets in your GitHub repository:

**Cloudflare (optional)**:
- `CLOUDFLARE_API_TOKEN`: Your Cloudflare API token
- `R2_ACCESS_KEY_ID`: Cloudflare R2 access key (for R2 backend)
- `R2_SECRET_ACCESS_KEY`: Cloudflare R2 secret key (for R2 backend)

**OVH (optional)**:
- `OVH_APPLICATION_KEY`: Your OVH application key
- `OVH_APPLICATION_SECRET`: Your OVH application secret
- `OVH_CONSUMER_KEY`: Your OVH consumer key

**Infomaniak (optional)**:
- `INFOMANIAK_TOKEN`: Your Infomaniak API token

**Backend Storage (optional)**:
- `TF_TOKEN_app_terraform_io`: Terraform Cloud API token
- `AWS_ACCESS_KEY_ID`: AWS S3 access key
- `AWS_SECRET_ACCESS_KEY`: AWS S3 secret key
- `ARM_CLIENT_ID`: Azure service principal client ID
- `ARM_CLIENT_SECRET`: Azure service principal client secret
- `ARM_SUBSCRIPTION_ID`: Azure subscription ID
- `ARM_TENANT_ID`: Azure tenant ID
- `GOOGLE_APPLICATION_CREDENTIALS`: Path to GCP service account JSON file

### Enabling CI/CD

The CI/CD pipeline is disabled by default to prevent failures. To enable it:

1. Configure all required GitHub secrets (see above)
2. Update your configuration files (zones, backend, etc.)
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
resource "infomaniak_domain_record" "example_a" {
  domain_id = data.infomaniak_domain.this.id
  type      = "A"
  name      = "subdomain"
  value     = "192.168.1.1"
  ttl       = 3600
}

# CNAME Record (subdomain)
resource "infomaniak_domain_record" "example_cname" {
  domain_id = data.infomaniak_domain.this.id
  type      = "CNAME"
  name      = "www"
  value     = "example.com."
  ttl       = 3600
}

# MX Record
resource "infomaniak_domain_record" "example_mx" {
  domain_id = data.infomaniak_domain.this.id
  type      = "MX"
  name      = "@"
  value     = "mail.example.com."
  priority  = 10
  ttl       = 3600
}

# CAA Record
resource "infomaniak_domain_record" "example_caa" {
  domain_id = data.infomaniak_domain.this.id
  type      = "CAA"
  name      = "@"
  value     = "0 issue \"letsencrypt.org\""
  ttl       = 3600
}
```

## 🔒 Security Best Practices

- API tokens are stored as GitHub secrets
- State file is encrypted in R2
- No sensitive data in repository
- Regular security updates via Dependabot

## 🐛 Troubleshooting

### Common Issues

1. **Provider version conflicts**: Run `terraform init -upgrade`
2. **State lock issues**: Check R2 bucket permissions
3. **API rate limits**: Wait and retry, or check token permissions
4. **OVH zone refresh**: OVH requires manual zone refresh after changes
5. **Infomaniak domain ID**: Ensure you have the correct domain ID from Infomaniak

### Useful Commands

```bash
# Check current state
terraform show

# Import existing DNS record (Cloudflare)
terraform import module.zone_name.cloudflare_dns_record.record_name zone_id/record_id

# Import existing DNS record (OVH)
terraform import module.zone_name.ovh_domain_zone_record.record_name zone_name/record_id

# Import existing DNS record (Infomaniak)
terraform import module.zone_name.infomaniak_domain_record.record_name domain_id/record_id

# Refresh state
terraform refresh

# Validate configuration
terraform validate
```

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