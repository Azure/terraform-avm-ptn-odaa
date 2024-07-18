terraform {
  required_version = "~> 1.5"
  required_providers {
    # TODO: Ensure all required providers are listed here and the version property includes a constraint on the maximum major version.
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.71"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
    azapi = {
      source = "azure/azapi"
      version = "~> 1.13.1"
    }
  }
}

  provider "azurerm" {
    features {}
    skip_provider_registration = true
  }
