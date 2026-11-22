# data.tf
# Data sources referenced by the root module.

data "azurerm_resource_group" "this" {
  name     = "rg-ss-compute-prod"
  location = local.location
  tags     = local.common_tags
}