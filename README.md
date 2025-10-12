# Terraform DNS Manager for Cloudflare - Template

[![CI Status](https://github.com/Net-Architect-Cloud/terraform-dns-manager-for-cloudflare/workflows/DNS%20Infrastructure%20CI/badge.svg)](https://github.com/Net-Architect-Cloud/terraform-dns-manager-for-cloudflare/actions)
[![GitHub forks](https://img.shields.io/github/forks/Net-Architect-Cloud/terraform-dns-manager-for-cloudflare?style=flat&logo=github)](https://github.com/Net-Architect-Cloud/terraform-dns-manager-for-cloudflare/network/members)
[![Terraform](https://img.shields.io/badge/Terraform-1.7+-623CE4?style=flat&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Cloudflare](https://img.shields.io/badge/Cloudflare-5.11+-F38020?style=flat&logo=cloudflare&logoColor=white)](https://registry.terraform.io/providers/cloudflare/cloudflare/latest)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A Terraform template for managing DNS records across multiple domains using Cloudflare as the DNS provider.

## 🏗️ Architecture

- **Provider**: Cloudflare DNS (v5.11+)
- **State Backend**: Cloudflare R2 Object Storage
- **CI/CD**: GitHub Actions
- **Structure**: Modular approach with separate zones

## 📁 Project Structure

```
.
├── main.tf                    # Main configuration calling zone modules
├── versions.tf                # Terraform and provider version constraints
├── providers.tf               # Cloudflare provider configuration
├── zones/                     # DNS zones organized by domain
│   └── example.com/
│       ├── records.tf         # DNS records for example.com
│       └── versions.tf        # Zone-specific provider requirements
└── .github/workflows/
    └── terraform.yml         # CI/CD pipeline
```

## 🚀 Getting Started

### Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.7.0
- Cloudflare account with API token
- Cloudflare R2 bucket for state storage

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
   export CLOUDFLARE_API_TOKEN="your_cloudflare_api_token"
   export AWS_ACCESS_KEY_ID="your_r2_access_key"
   export AWS_SECRET_ACCESS_KEY="your_r2_secret_key"
   export AWS_EC2_METADATA_DISABLED=true
   ```

4. **Update configuration**
   - Replace `YOUR_ACCOUNT_ID` in `versions.tf` with your Cloudflare Account ID
   - Update `terraform-state-dns` bucket name in `versions.tf`
   - Modify `zones/example.com/` to match your domain

5. **Initialize Terraform**
   ```bash
   source .env && terraform init
   ```

6. **Plan changes**
   ```bash
   source .env && terraform plan
   ```

7. **Apply changes**
   ```bash
   source .env && terraform apply
   ```

## 🔧 Configuration

### Cloudflare API Token

Your Cloudflare API token needs the following permissions:
- `Zone:DNS:Edit` - To manage DNS records
- `Zone:Zone:Read` - To read zone information

### R2 Backend Configuration

The Terraform state is stored in Cloudflare R2. Update the backend configuration in `versions.tf`:

```hcl
backend "s3" {
  bucket = "your-terraform-state-bucket"
  key    = "dns-infra/terraform.tfstate"
  endpoints = {
    s3 = "https://YOUR_ACCOUNT_ID.r2.cloudflarestorage.com"
  }
  region = "us-east-1"
  # ... additional configuration
}
```

## 🏃‍♂️ CI/CD Pipeline

The GitHub Actions workflow (`.github/workflows/terraform.yml`) automatically:

- **On Pull Requests**: Runs `terraform plan` and uploads the plan as an artifact
- **On Main Branch**: Runs `terraform apply` to deploy changes
- **Daily**: Runs drift detection to check for manual changes

### Required GitHub Secrets

Configure these secrets in your GitHub repository:

- `CLOUDFLARE_API_TOKEN`: Your Cloudflare API token
- `R2_ACCESS_KEY_ID`: Cloudflare R2 access key
- `R2_SECRET_ACCESS_KEY`: Cloudflare R2 secret key

## 📝 Managing DNS Records

### Adding a New Zone

1. Create a new directory under `zones/`
2. Copy the example zone structure
3. Update `records.tf` with your DNS records
4. Update `main.tf` to include the new module
5. Test locally and create a pull request

### Supported Record Types

- **A Records**: IPv4 addresses
- **AAAA Records**: IPv6 addresses
- **CNAME Records**: Canonical name records
- **MX Records**: Mail exchange records
- **TXT Records**: Text records (SPF, DKIM, DMARC)
- **SRV Records**: Service records

### Example Record Configurations

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

# A Record (APEX/root domain)
resource "cloudflare_dns_record" "apex_a" {
  zone_id = data.cloudflare_zone.this.zone_id
  name    = "@"
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

# CNAME Record (APEX/root domain) - Uses Cloudflare CNAME Flattening
resource "cloudflare_dns_record" "apex_cname" {
  zone_id = data.cloudflare_zone.this.zone_id
  name    = "@"
  type    = "CNAME"
  content = "target-domain.pages.dev"
  ttl     = 1
  proxied = true  # Required for APEX CNAME to work
}

# MX Record
resource "cloudflare_dns_record" "example_mx" {
  zone_id = data.cloudflare_zone.this.zone_id
  name    = "@"
  type    = "MX"
  content = "mail.example.com."
  priority = 10
  ttl     = 3600
}

# SRV Record
resource "cloudflare_dns_record" "example_srv" {
  zone_id = data.cloudflare_zone.this.zone_id
  name    = "_service._tcp"
  type    = "SRV"
  content = "10 5 443 target.example.com"
  ttl     = 3600
  
  data = {
    priority = 10
    weight   = 5
    port     = 443
    target   = "target.example.com."
  }
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

### Useful Commands

```bash
# Check current state
terraform show

# Import existing DNS record
terraform import module.zone_name.cloudflare_dns_record.record_name zone_id/record_id

# Refresh state
terraform refresh

# Validate configuration
terraform validate
```

## 📚 Documentation

- [Terraform Cloudflare Provider](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs)
- [Cloudflare API Documentation](https://developers.cloudflare.com/api/)
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