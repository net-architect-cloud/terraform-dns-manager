variable "cloudflare_api_token" {
  description = "Cloudflare API Token"
  type        = string
  sensitive   = true
  default     = "" # Empty if not used
}

variable "ovh_application_key" {
  description = "OVH Application Key"
  type        = string
  sensitive   = true
  default     = ""
}

variable "ovh_application_secret" {
  description = "OVH Application Secret"
  type        = string
  sensitive   = true
  default     = ""
}

variable "ovh_consumer_key" {
  description = "OVH Consumer Key"
  type        = string
  sensitive   = true
  default     = ""
}

variable "ovh_endpoint" {
  description = "OVH API Endpoint (ovh-eu, ovh-ca, ovh-us)"
  type        = string
  default     = "ovh-eu"
}

variable "infomaniak_token" {
  description = "Infomaniak API Token"
  type        = string
  sensitive   = true
  default     = "" # Empty if not used
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "ovh" {
  endpoint           = var.ovh_endpoint
  application_key    = var.ovh_application_key
  application_secret = var.ovh_application_secret
  consumer_key       = var.ovh_consumer_key
}

provider "infomaniak" {
  token = var.infomaniak_token
}