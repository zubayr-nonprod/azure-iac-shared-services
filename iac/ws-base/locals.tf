# locals.tf
# Local values used across the root module.

locals {
  common_tags = {
    Project     = "shared-services"
    Environment = "prod"
  }
}

locals {
  location = "northeurope"
  environment = "prod"

  rg_names = {
    storage  = "storage"
    network  = "network"
    compute  = "compute"
    security = "security"
  }
}