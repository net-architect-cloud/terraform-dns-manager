# Main configuration - calling zone modules

module "example_cloudflare_com" {
  source = "./zones/example-cloudflare.com"

  providers = {
    cloudflare = cloudflare
  }
}

module "example_ovh_com" {
  source = "./zones/example-ovh.com"

  providers = {
    ovh = ovh
  }
}

module "example_infomaniak_com" {
  source = "./zones/example-infomaniak.com"

  providers = {
    infomaniak = infomaniak
  }
}

# module "another_domain_com" {
#   source = "./zones/another-domain.com"
#   
#   providers = {
#     cloudflare = cloudflare
#   }
# }