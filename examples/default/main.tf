data "azurerm_client_config" "current" {}

data "azapi_resource_list" "listDbServersByPrimaryCloudExadataInfrastructure" {
  type                   = "Oracle.Database/cloudExadataInfrastructures/dbServers@2023-09-01"
  parent_id              = module.test-default.odaa_infra_instances.primary
  response_export_values = ["*"]
}

# This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.3"
}

locals {
  location         = "eastus"
  zones            = "1"
  enable_telemetry = true
  tags = {
    scenario = "Default"
    delete   = "yes"
  }
}

resource "random_string" "suffix" {
  length  = 5
  upper   = false
  special = false
}


# This is required for resource modules
resource "azurerm_resource_group" "this" {
  location = local.location
  name     = module.naming.resource_group.name_unique
  tags     = local.tags
}

# data "azurerm_resource_group" "this" {
#   name = azurerm_resource_group.this.id

# }

resource "tls_private_key" "generated_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azapi_resource" "ssh_public_key" {
  type      = "Microsoft.Compute/sshPublicKeys@2023-09-01"
  name      = "odaa_ssh_key"
  location  = local.location
  parent_id = azurerm_resource_group.this.id
  body = {
    properties = {
      publicKey = "${tls_private_key.generated_ssh_key.public_key_openssh}"
    }
  }
}

# This is the local file resource to store the private key
resource "local_file" "private_key" {
  filename = "${path.module}/id_rsa"
  content  = tls_private_key.generated_ssh_key.private_key_pem
}

#Log Analytics Workspace for Diagnostic Settings
resource "azurerm_log_analytics_workspace" "this" {
  location            = azurerm_resource_group.this.location
  name                = module.naming.log_analytics_workspace.name_unique
  resource_group_name = azurerm_resource_group.this.name
}

# This is the module call
# Do not specify location here due to the randomization above.
# Leaving location as `null` will cause the module to use the resource group location
# with a data source.
module "test-default" {
  source              = "../../"
  location            = local.location
  resource_group_name = azurerm_resource_group.this.name
  tags                = local.tags

  enable_telemetry = local.enable_telemetry

  virtual_networks = {
    primaryvnet = {
      name          = "vnet-odaa"
      address_space = ["10.0.0.0/16"]
      subnet = [
        {
          name                  = "snet-odaa"
          address_prefixes      = ["10.0.0.0/24"]
          delegate_to_oracle    = true
          associate_route_table = false
      }]
    }
  }

  cloud_exadata_infrastructure = {
    primary = {
      location : local.location
      name : "odaa-infra-${random_string.suffix.result}"
      zone : local.zones
      compute_count : 2
      display_name : "odaa-infra-${random_string.suffix.result}"
      storage_count : 3
      shape : "Exadata.X9M"
      maintenance_window_leadtime_in_weeks = 0
      maintenance_window_preference        = "NoPreference"
      maintenance_window_patching_mode     = "Rolling"
      createdby                            = "gerry"
      tags : {}
    }
  }

  cloud_exadata_vm_cluster = {
    cluster_one = {

      cloud_exadata_infrastructure_id = module.test-default.odaa_infra_instances.primary
      vnet_id                         = module.test-default.odaa_vnets.primaryvnet.resource_id
      subnet_id                       = module.test-default.odaa_vnets.primaryvnet.subnets.snet-odaa.resource_id
      ssh_public_keys                 = ["${tls_private_key.generated_ssh_key.public_key_openssh}"]
      db_servers = [
        jsondecode(data.azapi_resource_list.listDbServersByPrimaryCloudExadataInfrastructure
        .output).value[0].properties.ocid,
        jsondecode(data.azapi_resource_list.listDbServersByPrimaryCloudExadataInfrastructure
        .output).value[1].properties.ocid
      ]

      cluster_name : "odaa-cl"
      display_name : "odaa-cluster-${random_string.suffix.result}"
      data_storage_size_in_tbs   = 2
      dbnode_storage_size_in_gbs = 120
      time_zone                  = "UTC"
      memory_size_in_gbs         = 1000,
      hostname : "hostname-${random_string.suffix.result}"
      cpu_core_count : 4,
      data_storage_percentage : 80,
      is_local_backup_enabled = false,
      is_sparse_diskgroup_enabled : false,
      license_model : "LicenseIncluded",
      gi_version : "19.0.0.0",
      is_diagnostic_events_enabled : false,
      is_health_monitoring_enabled : false,
      is_incident_logs_enabled : false,
      backup_subnet_cidr : "172.17.5.0/24"
      ocpu_count : 3, # seems to not be required
      #nsg_cidrs: ????
      #backup_subnet_cidr: TEST THIS!
    }
  }

  diagnostic_settings = {
    sentToLogAnalytics={
      name                           = "sendToLogAnalytics"
      workspace_resource_id          = azurerm_log_analytics_workspace.this.id
      log_analytics_destination_type = "Dedicated"
      metric_categories              = ["AllMetrics"]
      log_groups                     = ["AllLogs"]

    }
  }

}




output "private_key_pem" {
  value     = tls_private_key.generated_ssh_key.private_key_pem
  sensitive = true
}
