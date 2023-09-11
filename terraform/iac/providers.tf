terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }

  required_version = ">= 1.1.0"
}

# Configure the Azure Provider
provider "azurerm" {
  subscription_id = "subscriptio_id"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  use_msi = true
}
