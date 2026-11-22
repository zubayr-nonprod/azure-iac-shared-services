# locals.tf
# Local values used across the root module.

# locals.tf
# Local values used across the root module.

locals {
  common_tags = {
    Project     = "shared-services"
    Environment = local.environment
  }

  location = "westeurope"
  environment = "prod"
}
