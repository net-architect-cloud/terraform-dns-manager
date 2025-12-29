variable "zone_name" {
  type    = string
  default = "example-ovh.com"
}

variable "ovh_endpoint" {
  type    = string
  default = "ovh-eu"
}

# Get the zone information
data "ovh_domain_zone" "this" {
  name = var.zone_name
}

# Example A record for root domain
resource "ovh_domain_zone_record" "apex" {
  zone      = data.ovh_domain_zone.this.name
  fieldtype = "A"
  target    = "192.168.1.1"  # Replace with your IP
  ttl       = 3600
}

# Example A record for subdomain
resource "ovh_domain_zone_record" "www" {
  zone      = data.ovh_domain_zone.this.name
  fieldtype = "A"
  subdomain = "www"
  target    = "192.168.1.1"  # Replace with your IP
  ttl       = 3600
}

# Example CNAME record
resource "ovh_domain_zone_record" "api" {
  zone      = data.ovh_domain_zone.this.name
  fieldtype = "CNAME"
  subdomain = "api"
  target    = "api.example.com."  # Replace with your target
  ttl       = 3600
}

# Example MX record
resource "ovh_domain_zone_record" "mx" {
  zone      = data.ovh_domain_zone.this.name
  fieldtype = "MX"
  target    = "10 mail.example-ovh.com."  # Replace with your mail server
  ttl       = 3600
}

# Example TXT record for SPF
resource "ovh_domain_zone_record" "spf" {
  zone      = data.ovh_domain_zone.this.name
  fieldtype = "TXT"
  target    = "v=spf1 -all"  # Replace with your SPF policy
  ttl       = 3600
}

# Example TXT record for DMARC
resource "ovh_domain_zone_record" "dmarc" {
  zone      = data.ovh_domain_zone.this.name
  fieldtype = "TXT"
  subdomain = "_dmarc"
  target    = "v=DMARC1; p=none; rua=mailto:dmarc@example-ovh.com"  # Replace with your DMARC policy
  ttl       = 3600
}

# Example AAAA record for IPv6
resource "ovh_domain_zone_record" "ipv6" {
  zone      = data.ovh_domain_zone.this.name
  fieldtype = "AAAA"
  subdomain = "ipv6"
  target    = "2001:db8::1"  # Replace with your IPv6 address
  ttl       = 3600
}

# Example SRV record
resource "ovh_domain_zone_record" "srv" {
  zone      = data.ovh_domain_zone.this.name
  fieldtype = "SRV"
  subdomain = "_service._tcp"
  target    = "10 5 443 target.example-ovh.com."  # priority weight port target
  ttl       = 3600
}

# Note: OVH provider does not have a "refresh" resource - changes are applied automatically
