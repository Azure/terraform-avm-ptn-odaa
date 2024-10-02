terraform {
  required_version = "~> 1.5"
  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~> 1.14.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.74"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.5.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.5"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = "true"
  features {}
}

locals {
  enable_telemetry   = true
  location           = "eastus"
  tags = {
    scenario         = "Default"
    project          = "Oracle Database @ Azure"
    createdby        = "ODAA Infra - AVM Module"
    delete           = "yes"
    deploy_timestamp = timestamp()
  }
  zone = "3"
  secondary_zone = "2"
}

# This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.3"
}

# Create SSH Keys for deployment of ODAA VM cluster

resource "tls_private_key" "generated_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azapi_resource" "ssh_public_key" {
  type = "Microsoft.Compute/sshPublicKeys@2023-09-01"
  body = {
    properties = {
      publicKey = tls_private_key.generated_ssh_key.public_key_openssh
    }
  }
  location  = local.location
  name      = "odaa_ssh_key"
  parent_id = azurerm_resource_group.this.id
}

resource "local_file" "private_key" {
  filename = "path.module/id_rsa"
  content  = tls_private_key.generated_ssh_key.private_key_pem
}

resource "random_string" "suffix" {
  length  = 5
  special = false
  upper   = false
}

resource "random_string" "secondary_suffix" {
  length  = 5
  special = false
  upper   = false
}

# This is required for resource modules
resource "azurerm_resource_group" "this" {
  location = local.location # module.regions.regions[random_integer.region_index.result].name
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
          name                  = "client"
          address_prefixes      = ["10.0.0.0/24"]
          delegate_to_oracle    = true
      }]
    },
    secondaryvnet = {
      name          = "vnet-secondary"
      address_space = ["10.1.0.0/16"]
      subnet = [
        {
          name                  = "client"
          address_prefixes      = ["10.1.0.0/24"]
          delegate_to_oracle    = true
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

 # Create the ODAA Infrastructure resource(s)
  cloud_exadata_infrastructure = {
    primary_exadata_infrastructure = {

      location                             = azurerm_resource_group.this.location
      name                                 = "odaa-infra-${random_string.suffix.result}"
      display_name                         = "odaa-infra-${random_string.suffix.result}"
      resource_group_id                    = azurerm_resource_group.this.id
      zone                                 = local.zone
      compute_count                        = 2
      storage_count                        = 3
      shape                                = "Exadata.X9M"
      maintenance_window_leadtime_in_weeks = 0
      maintenance_window_preference        = "NoPreference"
      maintenance_window_patching_mode     = "Rolling"
      tags                                 = local.tags
      enable_telemetry                     = local.enable_telemetry
    }

    secondary_exadata_infrastructure = {
      location                             = azurerm_resource_group.this.location
      name                                 = "odaa-infra-${random_string.secondary_suffix.result}"
      display_name                         = "odaa-infra-${random_string.secondary_suffix.result}"
      resource_group_id                    = azurerm_resource_group.this.id
      zone                                 = local.secondary_zone
      compute_count                        = 2
      storage_count                        = 3
      shape                                = "Exadata.X9M"
      maintenance_window_leadtime_in_weeks = 0
      maintenance_window_preference        = "NoPreference"
      maintenance_window_patching_mode     = "Rolling"
      tags                                 = local.tags
      enable_telemetry                     = local.enable_telemetry
    }
  }

  # Create the VM Cluster resource(s)
  cloud_exadata_vm_cluster = {
    primary_vm_cluster = {
      location                     = azurerm_resource_group.this.location
      resource_group_id            = azurerm_resource_group.this.id
      cloud_exadata_infra_name     = "primary_exadata_infrastructure"
      vnet_name                    = "primaryvnet"
      client_subnet_name           = "client"
      backup_subnet_cidr           = "172.17.5.0/24"
      ssh_public_keys              = [tls_private_key.generated_ssh_key.public_key_openssh]
      cluster_name                 = "odaa-vmcl-1"
      display_name                 = "odaa vm cluster primary"
      data_storage_size_in_tbs     = 2
      dbnode_storage_size_in_gbs   = 120
      time_zone                    = "UTC"
      memory_size_in_gbs           = 60
      hostname                     = "hostname-${random_string.suffix.result}"
      cpu_core_count               = 4
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
    secondary_vm_cluster = {
      location                     = azurerm_resource_group.this.location
      resource_group_id            = azurerm_resource_group.this.id
      cloud_exadata_infra_name     = "secondary_exadata_infrastructure"
      vnet_name                    = "secondaryvnet"
      client_subnet_name           = "client"
      backup_subnet_cidr           = "172.17.6.0/24"
      ssh_public_keys              = [tls_private_key.generated_ssh_key.public_key_openssh]
      cluster_name                 = "odaa-vmcl-2"
      display_name                 = "odaa vm cluster secondary"
      data_storage_size_in_tbs     = 2
      dbnode_storage_size_in_gbs   = 120
      time_zone                    = "UTC"
      memory_size_in_gbs           = 60
      hostname                     = "hostname-${random_string.secondary_suffix.result}"
      cpu_core_count               = 4
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

}
