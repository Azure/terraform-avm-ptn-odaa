variable "location" {
  type        = string
  description = "Azure region where the resource should be deployed."
  nullable    = false
}



# This is required for most resource modules
variable "resource_group_name" {
  type        = string
  description = "The resource group where the resources will be deployed."
}

# required AVM interfaces
# remove only if not supported by the resource
# tflint-ignore: terraform_unused_declarations
variable "customer_managed_key" {
  type = object({
    key_vault_resource_id = string
    key_name              = string
    key_version           = optional(string, null)
    user_assigned_identity = optional(object({
      resource_id = string
    }), null)
  })
  default     = null
  description = <<DESCRIPTION
A map describing customer-managed keys to associate with the resource. This includes the following properties:
- `key_vault_resource_id` - The resource ID of the Key Vault where the key is stored.
- `key_name` - The name of the key.
- `key_version` - (Optional) The version of the key. If not specified, the latest version is used.
- `user_assigned_identity` - (Optional) An object representing a user-assigned identity with the following properties:
  - `resource_id` - The resource ID of the user-assigned identity.
DESCRIPTION  
}

variable "diagnostic_settings" {
  type = map(object({
    name                                     = optional(string, null)
    log_categories                           = optional(set(string), [])
    log_groups                               = optional(set(string), ["allLogs"])
    metric_categories                        = optional(set(string), ["AllMetrics"])
    log_analytics_destination_type           = optional(string, "Dedicated")
    workspace_resource_id                    = optional(string, null)
    storage_account_resource_id              = optional(string, null)
    event_hub_authorization_rule_resource_id = optional(string, null)
    event_hub_name                           = optional(string, null)
    marketplace_partner_resource_id          = optional(string, null)
  }))
  default     = {}
  description = <<DESCRIPTION
A map of diagnostic settings to create on the Key Vault. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `name` - (Optional) The name of the diagnostic setting. One will be generated if not set, however this will not be unique if you want to create multiple diagnostic setting resources.
- `log_categories` - (Optional) A set of log categories to send to the log analytics workspace. Defaults to `[]`.
- `log_groups` - (Optional) A set of log groups to send to the log analytics workspace. Defaults to `["allLogs"]`.
- `metric_categories` - (Optional) A set of metric categories to send to the log analytics workspace. Defaults to `["AllMetrics"]`.
- `log_analytics_destination_type` - (Optional) The destination type for the diagnostic setting. Possible values are `Dedicated` and `AzureDiagnostics`. Defaults to `Dedicated`.
- `workspace_resource_id` - (Optional) The resource ID of the log analytics workspace to send logs and metrics to.
- `storage_account_resource_id` - (Optional) The resource ID of the storage account to send logs and metrics to.
- `event_hub_authorization_rule_resource_id` - (Optional) The resource ID of the event hub authorization rule to send logs and metrics to.
- `event_hub_name` - (Optional) The name of the event hub. If none is specified, the default event hub will be selected.
- `marketplace_partner_resource_id` - (Optional) The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic LogsLogs.
DESCRIPTION  
  nullable    = false

  validation {
    condition     = alltrue([for _, v in var.diagnostic_settings : contains(["Dedicated", "AzureDiagnostics"], v.log_analytics_destination_type)])
    error_message = "Log analytics destination type must be one of: 'Dedicated', 'AzureDiagnostics'."
  }
  validation {
    condition = alltrue(
      [
        for _, v in var.diagnostic_settings :
        v.workspace_resource_id != null || v.storage_account_resource_id != null || v.event_hub_authorization_rule_resource_id != null || v.marketplace_partner_resource_id != null
      ]
    )
    error_message = "At least one of `workspace_resource_id`, `storage_account_resource_id`, `marketplace_partner_resource_id`, or `event_hub_authorization_rule_resource_id`, must be set."
  }
}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see <https://aka.ms/avm/telemetryinfo>.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
}

variable "lock" {
  type = object({
    kind = string
    name = optional(string, null)
  })
  default     = null
  description = <<DESCRIPTION
Controls the Resource Lock configuration for this resource. The following properties can be specified:

- `kind` - (Required) The type of lock. Possible values are `\"CanNotDelete\"` and `\"ReadOnly\"`.
- `name` - (Optional) The name of the lock. If not specified, a name will be generated based on the `kind` value. Changing this forces the creation of a new resource.
DESCRIPTION

  validation {
    condition     = var.lock != null ? contains(["CanNotDelete", "ReadOnly"], var.lock.kind) : true
    error_message = "The lock level must be one of: 'None', 'CanNotDelete', or 'ReadOnly'."
  }
}

# tflint-ignore: terraform_unused_declarations
variable "managed_identities" {
  type = object({
    system_assigned            = optional(bool, false)
    user_assigned_resource_ids = optional(set(string), [])
  })
  default     = {}
  description = <<DESCRIPTION
Controls the Managed Identity configuration on this resource. The following properties can be specified:

- `system_assigned` - (Optional) Specifies if the System Assigned Managed Identity should be enabled.
- `user_assigned_resource_ids` - (Optional) Specifies a list of User Assigned Managed Identity resource IDs to be assigned to this resource.
DESCRIPTION
  nullable    = false
}

variable "private_endpoints" {
  type = map(object({
    name = optional(string, null)
    role_assignments = optional(map(object({
      role_definition_id_or_name             = string
      principal_id                           = string
      description                            = optional(string, null)
      skip_service_principal_aad_check       = optional(bool, false)
      condition                              = optional(string, null)
      condition_version                      = optional(string, null)
      delegated_managed_identity_resource_id = optional(string, null)
    })), {})
    lock = optional(object({
      kind = string
      name = optional(string, null)
    }), null)
    tags                                    = optional(map(string), null)
    subnet_resource_id                      = string
    private_dns_zone_group_name             = optional(string, "default")
    private_dns_zone_resource_ids           = optional(set(string), [])
    application_security_group_associations = optional(map(string), {})
    private_service_connection_name         = optional(string, null)
    network_interface_name                  = optional(string, null)
    location                                = optional(string, null)
    resource_group_name                     = optional(string, null)
    ip_configurations = optional(map(object({
      name               = string
      private_ip_address = string
    })), {})
  }))
  default     = {}
  description = <<DESCRIPTION
A map of private endpoints to create on this resource. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `name` - (Optional) The name of the private endpoint. One will be generated if not set.
- `role_assignments` - (Optional) A map of role assignments to create on the private endpoint. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time. See `var.role_assignments` for more information.
- `lock` - (Optional) The lock level to apply to the private endpoint. Default is `None`. Possible values are `None`, `CanNotDelete`, and `ReadOnly`.
- `tags` - (Optional) A mapping of tags to assign to the private endpoint.
- `subnet_resource_id` - The resource ID of the subnet to deploy the private endpoint in.
- `private_dns_zone_group_name` - (Optional) The name of the private DNS zone group. One will be generated if not set.
- `private_dns_zone_resource_ids` - (Optional) A set of resource IDs of private DNS zones to associate with the private endpoint. If not set, no zone groups will be created and the private endpoint will not be associated with any private DNS zones. DNS records must be managed external to this module.
- `application_security_group_resource_ids` - (Optional) A map of resource IDs of application security groups to associate with the private endpoint. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.
- `private_service_connection_name` - (Optional) The name of the private service connection. One will be generated if not set.
- `network_interface_name` - (Optional) The name of the network interface. One will be generated if not set.
- `location` - (Optional) The Azure location where the resources will be deployed. Defaults to the location of the resource group.
- `resource_group_name` - (Optional) The resource group where the resources will be deployed. Defaults to the resource group of this resource.
- `ip_configurations` - (Optional) A map of IP configurations to create on the private endpoint. If not specified the platform will create one. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.
  - `name` - The name of the IP configuration.
  - `private_ip_address` - The private IP address of the IP configuration.
DESCRIPTION
  nullable    = false
}

# This variable is used to determine if the private_dns_zone_group block should be included,
# or if it is to be managed externally, e.g. using Azure Policy.
# https://github.com/Azure/terraform-azurerm-avm-res-keyvault-vault/issues/32
# Alternatively you can use AzAPI, which does not have this issue.
variable "private_endpoints_manage_dns_zone_group" {
  type        = bool
  default     = true
  description = "Whether to manage private DNS zone groups with this module. If set to false, you must manage private DNS zone groups externally, e.g. using Azure Policy."
  nullable    = false
}

variable "role_assignments" {
  type = map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    description                            = optional(string, null)
    skip_service_principal_aad_check       = optional(bool, false)
    condition                              = optional(string, null)
    condition_version                      = optional(string, null)
    delegated_managed_identity_resource_id = optional(string, null)
  }))
  default     = {}
  description = <<DESCRIPTION
A map of role assignments to create on this resource. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `role_definition_id_or_name` - The ID or name of the role definition to assign to the principal.
- `principal_id` - The ID of the principal to assign the role to.
- `description` - The description of the role assignment.
- `skip_service_principal_aad_check` - If set to true, skips the Azure Active Directory check for the service principal in the tenant. Defaults to false.
- `condition` - The condition which will be used to scope the role assignment.
- `condition_version` - The version of the condition syntax. Valid values are '2.0'.

> Note: only set `skip_service_principal_aad_check` to true if you are assigning a role to a service principal.
DESCRIPTION
  nullable    = false
}

# tflint-ignore: terraform_unused_declarations
variable "tags" {
  type = map(string)
  default = {
    scenario = "ODAA Terraform Deployment"
  }
  description = "(Optional) Tags of the resource."
}

# Virtual networks for hosting the Exadata appliance(s)
variable "virtual_networks" {
  type = map(object({
    address_space = list(string)
    name          = string
    ddos_protection_plan = optional(object({
      enable = bool
      id     = string
    }), null)
    encryption = optional(object({
      enforcement = string
    }), null)
    flow_timeout_in_minutes = optional(number, null)
    resource_group_name     = optional(string, null)
    subnet = optional(set(object({
      delegate_to_oracle = bool
      address_prefixes   = list(string)
      name               = string
      security_group     = optional(string, null)
    })), null)
    peerings = optional(map(object({
      remote_vnet_id          = string
      allow_forwarded_traffic = bool
      allow_gateway_transit   = bool
      use_remote_gateways     = bool
    })), {})
  }))
  description = "Virtual Network(s) for hosting Exadata appliances"
  default = {
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
}

variable "route_tables" {
  type = map(object({
    name                          = string
    disable_bgp_route_propagation = optional(bool, null)
    route = optional(set(object({
      address_prefix         = string
      name                   = string
      next_hop_in_ip_address = string
      next_hop_type          = string
    })), null)
  }))
  description = "Route tables for Exadata appliance vnets/subnets"
  default     = {}
}


variable "prefix" {
  type        = string
  description = "Prefix of the name under 6 characters"
  default = ""
  validation {
    condition     = length(var.prefix) < 6 && lower(var.prefix) == var.prefix
    error_message = "The prefix value must be lowercase and < 5 chars."
  }
}

############################################################################################################
##################### Cloud Exadata Infrastructure variables
############################################################################################################

variable "cloud_exadata_infrastructure" {
  type = map(object({
    name                                 = string
    location                             = string
    zone                                 = optional(string, null)
    compute_count                        = number
    display_name                         = string
    createdby                            = string
    maintenance_window_leadtime_in_weeks = number
    maintenance_window_preference        = string
    maintenance_window_patching_mode     = string
    shape                                = string
    storage_count                        = number
    tags                                 = optional(map(string), null)
  }))
  default = {}
  description = <<DESCRIPTION
  Cloud Exadata Infrastructure resources  

  - `name` - The name of the Cloud Exadata Infrastructure.
  - `location` - The location of the Cloud Exadata Infrastructure.
  - `zone` - (Optional) The availability zone of the Cloud Exadata Infrastructure.
  - `compute_count` - The number of compute nodes in the Cloud Exadata Infrastructure.
  - `display_name` - The display name of the Cloud Exadata Infrastructure.
  - `maintenance_window_leadtime_in_weeks` - The maintenance window load time in weeks.
  - `maintenance_window_preference` - The maintenance window preference.
  - `maintenance_window_patching_mode` - The maintenance window patching mode.
  - `shape` - The shape of the Cloud Exadata Infrastructure.
  - `storage_count` - The number of storage servers in the Cloud Exadata Infrastructure.
  - `tags` - (Optional) A mapping of tags to assign to the Cloud Exadata Infrastructure.
DESCRIPTION
}

############################################################################################################
##################### Cloud Exadata VM Cliuster variables
############################################################################################################

# variable "cloud_exadata_vm_cluster" {
#   type = map(object({
#     cluster_name                    = string
#     display_name                    = string
#     data_storage_size_in_tbs        = number
#     dbnode_storage_size_in_gbs      = number
#     time_zone                       = string
#     hostname                        = string
#     domain                          = string
#     cpu_core_count                  = number
#     ocpu_count                      = number
#     data_storage_percentage         = number
#     is_local_backup_enabled         = bool
#     cloud_exadata_infrastructure_id = string
#     is_sparse_diskgroup_enabled     = bool
#     ssh_public_keys                 = string
#     nsg_cidrs = optional(set(object({
#       source = string
#       destination_port_range = optional(set(object({
#         min = string
#         max = string
#       })), null)
#     })), null)
#     license_model                = string
#     scan_listener_port_tcp       = number
#     scan_listener_port_tcp_ssl   = number
#     vnet_id                      = string
#     gi_version                   = string
#     subnet_id                    = string
#     backup_subnet_cidr           = string
#     is_diagnostic_events_enabled = optional(bool, false)
#     is_health_monitoring_enabled = optional(bool, false)
#     is_incident_logs_enabled     = optional(bool, false)
#   }))
#   default     = {}
#   description = <<DESCRIPTION
#   Cloud Exadata VM Cluster resources

#   - `cluster_name` - The name of the Cloud Exadata VM Cluster.
#   - `display_name` - The display name of the Cloud Exadata VM Cluster.
#   - `data_storage_size_in_tbs` - The data storage size in TBs.
#   - `dbnode_storage_size_in_gbs` - The DB node storage size in GBs.
#   - `time_zone` - The time zone of the Cloud Exadata VM Cluster.
#   - `hostname` - The hostname of the Cloud Exadata VM Cluster.
#   - `domain` - The domain of the Cloud Exadata VM Cluster.
#   - `cpu_core_count` - The CPU core count of the Cloud Exadata VM Cluster.
#   - `ocpu_count` - The OCPU count of the Cloud Exadata VM Cluster.
#   - `data_storage_percentage` - The data storage percentage of the Cloud Exadata VM Cluster.
#   - `is_local_backup_enabled` - The local backup enabled status of the Cloud Exadata VM Cluster.
#   - `cloud_exadata_infrastructure_id` - The Cloud Exadata Infrastructure ID of the Cloud Exadata VM Cluster.
#   - `is_sparse_diskgroup_enabled` - The sparse diskgroup enabled status of the Cloud Exadata VM Cluster.
#   - `ssh_public_keys` - The SSH public keys of the Cloud Exadata VM Cluster.
#   - `nsg_cidrs` - (Optional) A set of NSG CIDRs of the Cloud Exadata VM Cluster.
#   - `license_model` - The license model of the Cloud Exadata VM Cluster.
#   - `scan_listener_port_tcp` - The scan listener port TCP of the Cloud Exadata VM Cluster.
#   - `scan_listener_port_tcp_ssl` - The scan listener port TCP SSL of the Cloud Exadata VM Cluster.
#   - `vnet_id` - The VNet ID of the Cloud Exadata VM Cluster.
#   - `gi_version` - The GI version of the Cloud Exadata VM Cluster.
#   - `subnet_id` - The subnet ID of the Cloud Exadata VM Cluster.
#   - `backup_subnet_cidr` - The backup subnet CIDR of the Cloud Exadata VM Cluster.
#   - `is_diagnostic_events_enabled` - (Optional) The diagnostic events enabled status of the Cloud Exadata VM Cluster.
#   - `is_health_monitoring_enabled` - (Optional) The health monitoring enabled status of the Cloud Exadata VM Cluster.
#   - `is_incident_logs_enabled` - (Optional) The incident logs enabled status of the Cloud Exadata VM Cluster.

# DESCRIPTION
# }
