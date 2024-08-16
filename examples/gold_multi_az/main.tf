# This example deploys a Maximum-availability architecture configuration, with Oracle
# appliances deployed in multiple Availability zones. 
terraform {
  required_version = "~> 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.74"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "azurerm" {
  features {}
}


## Section to provide a random Azure region for the resource group
# This allows us to randomize the region for the resource group.
module "regions" {
  source  = "Azure/regions/azurerm"
  version = "~> 0.3"
}

# This allows us to randomize the region for the resource group.
resource "random_integer" "region_index" {
  max = length(module.regions.regions) - 1
  min = 0
}
## End of section to provide a random Azure region for the resource group

# This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.3"
}

# This is required for resource modules
resource "azurerm_resource_group" "this" {
  location = module.regions.regions[random_integer.region_index.result].name
  name     = module.naming.resource_group.name_unique
}

# Multi-AZ Deployment of ODAA infratstructure/VM Cluster (Gold)
module "gold_multi_az" {
  source              = "../../"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  # Setup a Primary and a Secondary Vnet, for deploying ODAA resources
  virtual_networks = {
    primaryvnet = {
      name          = "vnet-primary"
      address_space = ["10.0.0.0/16"]
      subnet = [
        {
          name                  = "primary-client"
          address_prefixes      = ["10.0.0.0/24"]
          delegate_to_oracle    = true
          associate_route_table = false
        },
        {
          name                  = "primary-backup"
          address_prefixes      = ["10.0.1.0/24"]
          delegate_to_oracle    = false
          associate_route_table = false
      }]
    },
    secondaryvnet = {
      name          = "vnet-secondary"
      address_space = ["10.1.0.0/16"]
      subnet = [
        {
          name                  = "secondary-client"
          address_prefixes      = ["10.1.0.0/24"]
          delegate_to_oracle    = true
          associate_route_table = false
        },
        {
          name                  = "secondary-backup"
          address_prefixes      = ["10.1.1.0/24"]
          delegate_to_oracle    = false
          associate_route_table = false
      }]
    }
  }

  # Setup a peering between both the vnets
  odaa_vnet_peerings = {
    peering1 = {
      vnet_source_resource_group      = azurerm_resource_group.this.name
      vnet_source_name                = "vnet-primary"
      vnet_destination_name           = "vnet-secondary"
      vnet_destination_resource_group = azurerm_resource_group.this.name
    }
  }
  enable_telemetry             = var.enable_telemetry # see variables.tf
  cloud_exadata_infrastructure = {}
  cloud_exadata_vm_cluster     = {}
}
