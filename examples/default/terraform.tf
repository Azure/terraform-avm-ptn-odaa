terraform {
  required_version = ">= 1.9.2"
  required_providers {
    # TODO: Ensure all required providers are listed here and the version property includes a constraint on the maximum major version.
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.74"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
    azapi = {
      source = "azure/azapi"
      version = "~> 1.14.0"
    }
  }
}

  provider "azurerm" {
    features {}
    skip_provider_registration = true
  }
