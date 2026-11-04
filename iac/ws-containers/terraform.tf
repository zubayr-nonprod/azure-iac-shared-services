# terraform.tf
# Terraform settings, backend, and required providers.

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  # Values are supplied at 'terraform init' by the shared tf-azure-template pipeline.
  backend "azurerm" {}
}
