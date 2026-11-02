# main.tf
# Root module composition. Wire up child modules and resources here.

# module "rg_base_naming" {
#   source = "./modules/naming"
#   suffix = ["ss",local.common_tags.Environment]
# }

resource "azurerm_resource_group" "storage_rg" {
  name     = "rg-ss-storage-prod"
  location = "northeurope"

  tags     = local.common_tags
}