# Main configuration - calling zone modules

module "example_com" {
  source = "./zones/example.com"
  
  providers = {
    cloudflare = cloudflare
  }
}

# Add more zones as needed
# module "another_domain_com" {
#   source = "./zones/another-domain.com"
#   
#   providers = {
#     cloudflare = cloudflare
#   }
# }