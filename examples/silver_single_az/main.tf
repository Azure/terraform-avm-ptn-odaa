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


resource "random_string" "suffix" {
  length  = 5
  special = false
  upper   = false
}

locals {
  enable_telemetry = true
  location         = "eastus"
  tags = {
    scenario         = "Default"
    project          = "Oracle Database @ Azure"
    createdby        = "ODAA Infra - AVM Module"
    delete           = "yes"
    deploy_timestamp = timestamp()
  }
  zone = "3"
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

# Single-AZ Deployment of ODAA infratstructure/VM Cluster (Silver)
module "silver_single_az" {
  source              = "../../"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  # Create the Virtual Networks
  virtual_networks = {
    primaryvnet = {
      name          = "vnet-odaa"
      address_space = ["10.0.0.0/16"]
      subnet = [
        {
          name                  = "client"
          address_prefixes      = ["10.0.0.0/24"]
          delegate_to_oracle    = true
          associate_route_table = false
        },
        {
          name                  = "backup"
          address_prefixes      = ["10.0.1.0/24"]
          delegate_to_oracle    = false
          associate_route_table = false
      }]
    }
  }

  # No peerings, only one vnet
  odaa_vnet_peerings = {}

  # Create the ODAA Infrastructure resource(s)
  cloud_exadata_infrastructure = {
    primary_exadata_infrastructure = {

      location          = azurerm_resource_group.this.location
      name              = "odaa-infra-primary"
      display_name      = "odaa-infra-primary"
      resource_group_id = azurerm_resource_group.this.id
      zone              = local.zone
      compute_count     = 2
      storage_count     = 3
      tags              = local.tags
      enable_telemetry  = local.enable_telemetry
    }
  }

  # Create the VM Cluster resource(s)
  # cloud_exadata_vm_cluster = {}
  cloud_exadata_vm_cluster = {
    primary_vm_cluster = {
      location                     = azurerm_resource_group.this.location
      resource_group_id            = azurerm_resource_group.this.id
      cloud_exadata_infra_name     = "primary_exadata_infrastructure"
      vnet_name                    = "primaryvnet"
      client_subnet_name           = "client"
      backup_subnet_name           = "backup"
      ssh_public_keys              = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDeCq3pYt6uTuIKv8nreycCgwsvLQFEJ0q7WPswOckhaG87kxopxXfXbGiMbbgcgVDg+0UIWZB6ZTspFHR5pS/U6CeJzPFQ8C6iI3Evip4jqyaQ1uY87mjMZGWKa+OAgK7gmzWCZmXNcQ1Mmd/hJrQCQGHah3HiPWl1j96s6nxoI4dW6MKggdC2WFWVxIAGLYqWMndMOGVRfiYPv3c2jliTnvZK/KJgJV4vu8+BbpvsIbqhJDx4ONk+9KfYLb/pA9QlJFVBki5VUlYDo565JNclS5Y5Qu0/tbwIOj06Gr4kUy/CgrFFnReykT7+OXbjyPD7O6s+2yzK+H5UZFtHuzlRfJGwqfG9jk/5EPhnyW5eb/tO07icSjVnfdCncTspjZMnwEbHwF4ksYQKM45ArHLHKAXB+uExpoqBysHS5hXLCwG2NclwlC6Lsm+BOacdFwFWMCTGEsGf36c6eMQexnr2U0WnH7qxrJBjxyqwCLeWWQslw297kU/2IvuTWpDoMqM="]
      cluster_name                 = "odaa-vmcl"
      display_name                 = "odaa vm cluster"
      data_storage_size_in_tbs     = 2
      dbnode_storage_size_in_gbs   = 120
      time_zone                    = "UTC"
      memory_size_in_gbs           = 60
      hostname                     = "hostname-${random_string.suffix.result}"
      domain                       = "odaa-domain1"
      cpu_core_count               = 2
      data_storage_percentage      = 80
      is_local_backup_enabled      = false
      is_sparse_diskgroup_enabled  = false
      license_model                = "LicenseIncluded"
      gi_version                   = "19.0.0.0"
      is_diagnostic_events_enabled = true
      is_health_monitoring_enabled = true
      is_incident_logs_enabled     = true
      tags                         = local.tags
      enable_telemetry             = var.enable_telemetry
    }
  }

  enable_telemetry = var.enable_telemetry # see variables.tf

}
