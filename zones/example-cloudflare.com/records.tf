variable "zone_name" {
  type    = string
  default = "example.com"
}

data "cloudflare_zone" "this" {
  filter = {
    name = var.zone_name
  }
}

# Example A record for root domain
resource "cloudflare_dns_record" "apex" {
  zone_id = data.cloudflare_zone.this.zone_id
  name    = "@"
  type    = "A"
  content = "192.168.1.1"  # Replace with your IP
  ttl     = 3600
  proxied = false
}

# Example CNAME record for www
resource "cloudflare_dns_record" "www" {
  zone_id = data.cloudflare_zone.this.zone_id
  name    = "www"
  type    = "CNAME"
  content = var.zone_name
  ttl     = 1
  proxied = true
}

# Example MX record
resource "cloudflare_dns_record" "mx" {
  zone_id = data.cloudflare_zone.this.zone_id
  name    = "@"
  type    = "MX"
  content = "mail.example.com."  # Replace with your mail server
  priority = 10
  ttl     = 3600
}

# Example TXT record for SPF
resource "cloudflare_dns_record" "spf" {
  zone_id = data.cloudflare_zone.this.zone_id
  name    = "@"
  type    = "TXT"
  content = "\"v=spf1 -all\""  # Replace with your SPF policy
  ttl     = 3600
}

# Example TXT record for DMARC
resource "cloudflare_dns_record" "dmarc" {
  zone_id = data.cloudflare_zone.this.zone_id
  name    = "_dmarc"
  type    = "TXT"
  content = "\"v=DMARC1; p=none; rua=mailto:dmarc@example.com\""  # Replace with your DMARC policy
  ttl     = 3600
}