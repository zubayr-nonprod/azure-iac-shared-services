# terraform.tf
# Terraform settings, backend, and required providers.

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  # Values are supplied at 'terraform init' by the shared tf-azure-template pipeline.
  backend "azurerm" {}
}

provider "azurerm" {
  features {}

  # azurerm v4 requires an explicit subscription.
  # You can also leave this out and set ARM_SUBSCRIPTION_ID instead.
  subscription_id = var.subscription_id
}