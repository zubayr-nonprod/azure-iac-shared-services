# locals.tf
# Local values used across the root module.

locals {
  common_tags = {
    Project     = "shared-services"
    Environment = "prod"
  }
}
