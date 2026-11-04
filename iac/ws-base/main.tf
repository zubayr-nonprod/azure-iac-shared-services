# main.tf
# Root module composition. Wire up child modules and resources here.

# module "rg_base_naming" {
#   source = "./modules/naming"
#   suffix = ["ss",local.common_tags.Environment]
# }

resource "azurerm_resource_group" "base_rg" {
  for_each = local.rg_names
  name     = "rg-ss-${each.value}-${local.environment}"
  location = local.location

  tags     = local.common_tags
}

# resource "azurerm_resource_group" "network_rg" {
#   name     = "rg-ss-${local.rg_names.network}-${local.environment}"
#   location = local.location

#   tags     = local.common_tags
# }

# resource "azurerm_resource_group" "compute_rg" {
#   name     = "rg-ss-${local.rg_names.compute}-${local.environment}"
#   location = local.location

#   tags     = local.common_tags
# }

# resource "azurerm_resource_group" "security_rg" {
#   name     = "rg-ss-${local.rg_names.security}-${local.environment}"
#   location = local.location

#   tags     = local.common_tags
# }