<!-- BEGIN_TF_DOCS -->
# terraform-azurerm-avm-template

This is a template repo for Terraform Azure Verified Modules.

Things to do:

1. Set up a GitHub repo environment called `test`.
1. Configure environment protection rule to ensure that approval is required before deploying to this environment.
1. Create a user-assigned managed identity in your test subscription.
1. Create a role assignment for the managed identity on your test subscription, use the minimum required role.
1. Configure federated identity credentials on the user assigned managed identity. Use the GitHub environment.
1. Search and update TODOs within the code and remove the TODO comments once complete.

> [!IMPORTANT]
> As the overall AVM framework is not GA (generally available) yet - the CI framework and test automation is not fully functional and implemented across all supported languages yet - breaking changes are expected, and additional customer feedback is yet to be gathered and incorporated. Hence, modules **MUST NOT** be published at version `1.0.0` or higher at this time.
>
> All module **MUST** be published as a pre-release version (e.g., `0.1.0`, `0.1.1`, `0.2.0`, etc.) until the AVM framework becomes GA.
>
> However, it is important to note that this **DOES NOT** mean that the modules cannot be consumed and utilized. They **CAN** be leveraged in all types of environments (dev, test, prod etc.). Consumers can treat them just like any other IaC module and raise issues or feature requests against them as they learn from the usage of the module. Consumers should also read the release notes for each version, if considering updating to a more recent version of a module to see if there are any considerations or breaking changes etc.

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.5)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 3.71)

- <a name="requirement_modtm"></a> [modtm](#requirement\_modtm) (~> 0.3)

- <a name="requirement_random"></a> [random](#requirement\_random) (~> 3.5)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 3.71)

- <a name="provider_modtm"></a> [modtm](#provider\_modtm) (~> 0.3)

- <a name="provider_random"></a> [random](#provider\_random) (~> 3.5)

## Resources

The following resources are used by this module:

- [azurerm_route_table.rt_odaa](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table) (resource)
- [modtm_telemetry.telemetry](https://registry.terraform.io/providers/Azure/modtm/latest/docs/resources/telemetry) (resource)
- [random_string.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) (resource)
- [random_uuid.telemetry](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) (resource)
- [azurerm_client_config.telemetry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)
- [azurerm_resource_group.odaa_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) (data source)
- [modtm_module_source.telemetry](https://registry.terraform.io/providers/Azure/modtm/latest/docs/data-sources/module_source) (data source)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_cloud_exadata_infrastructure"></a> [cloud\_exadata\_infrastructure](#input\_cloud\_exadata\_infrastructure)

Description:   Cloud Exadata Infrastructure resources

  - `name` - The name of the Cloud Exadata Infrastructure.
  - `location` - The location of the Cloud Exadata Infrastructure.
  - `zone` - (Optional) The availability zone of the Cloud Exadata Infrastructure.
  - `compute_count` - The number of compute nodes in the Cloud Exadata Infrastructure.
  - `display_name` - The display name of the Cloud Exadata Infrastructure.
  - `maintenance_window_loadtime_in_weeks` - The maintenance window load time in weeks.
  - `maintenance_window_preference` - The maintenance window preference.
  - `maintenance_window_patching_mode` - The maintenance window patching mode.
  - `shape` - The shape of the Cloud Exadata Infrastructure.
  - `storage_count` - The number of storage servers in the Cloud Exadata Infrastructure.
  - `tags` - (Optional) A mapping of tags to assign to the Cloud Exadata Infrastructure.

Type:

```hcl
map(object({
    name                                 = string
    location                             = string
    zone                                 = string
    compute_count                        = number
    display_name                         = string
    maintenance_window_loadtime_in_weeks = optional(string, 0)
    maintenance_window_preference        = optional(string, "NoPreference")
    maintenance_window_patching_mode     = optional(string, "Rolling")
    shape                                = optional(string, "Exadata.X9M")
    storage_count                        = number
    tags                                 = optional(map(string))
  }))
```

### <a name="input_cloud_exadata_vm_cluster"></a> [cloud\_exadata\_vm\_cluster](#input\_cloud\_exadata\_vm\_cluster)

Description:   Cloud Exadata VM Cluster resources

  - `cluster_name` - The name of the Cloud Exadata VM Cluster.
  - `display_name` - The display name of the Cloud Exadata VM Cluster.
  - `data_storage_size_in_tbs` - The data storage size in TBs.
  - `dbnode_storage_size_in_gbs` - The DB node storage size in GBs.
  - `time_zone` - The time zone of the Cloud Exadata VM Cluster.
  - `hostname` - The hostname of the Cloud Exadata VM Cluster.
  - `domain` - The domain of the Cloud Exadata VM Cluster.
  - `cpu_core_count` - The CPU core count of the Cloud Exadata VM Cluster.
  - `ocpu_count` - The OCPU count of the Cloud Exadata VM Cluster.
  - `data_storage_percentage` - The data storage percentage of the Cloud Exadata VM Cluster.
  - `is_local_backup_enabled` - The local backup enabled status of the Cloud Exadata VM Cluster.
  - `cloud_exadata_infrastructure_id` - The Cloud Exadata Infrastructure ID of the Cloud Exadata VM Cluster.
  - `is_sparse_diskgroup_enabled` - The sparse diskgroup enabled status of the Cloud Exadata VM Cluster.
  - `ssh_public_keys` - The SSH public keys of the Cloud Exadata VM Cluster.
  - `nsg_cidrs` - (Optional) A set of NSG CIDRs of the Cloud Exadata VM Cluster.
  - `license_model` - The license model of the Cloud Exadata VM Cluster.
  - `vnet_id` - The VNet ID of the Cloud Exadata VM Cluster.
  - `gi_version` - The GI version of the Cloud Exadata VM Cluster.
  - `subnet_id` - The subnet ID of the Cloud Exadata VM Cluster.
  - `backup_subnet_cidr` - The backup subnet CIDR of the Cloud Exadata VM Cluster.
  - `is_diagnostic_events_enabled` - (Optional) The diagnostic events enabled status of the Cloud Exadata VM Cluster.
  - `is_health_monitoring_enabled` - (Optional) The health monitoring enabled status of the Cloud Exadata VM Cluster.
  - `is_incident_logs_enabled` - (Optional) The incident logs enabled status of the Cloud Exadata VM Cluster.

Type:

```hcl
map(object({
    cluster_name               = string
    display_name               = string
    cloud_exadata_infra_name   = string
    location                   = string
    data_storage_size_in_tbs   = number
    dbnode_storage_size_in_gbs = number
    hostname                   = string
    cpu_core_count             = number
    data_storage_percentage    = number
    memory_size_in_gbs         = number

    ssh_public_keys = list(string)
    nsg_cidrs = optional(set(object({
      source = string
      destination_port_range = optional(object({
        min = string
        max = string
      }), null)
    })))
    license_model                = optional(string, "LicenseIncluded")
    vnet_name                    = string
    client_subnet_name           = string
    backup_subnet_cidr           = string
    gi_version                   = optional(string, "19.0.0.0")
    time_zone                    = string
    is_local_backup_enabled      = optional(bool, true)
    is_sparse_diskgroup_enabled  = optional(bool, true)
    is_diagnostic_events_enabled = optional(bool, false)
    is_health_monitoring_enabled = optional(bool, false)
    is_incident_logs_enabled     = optional(bool, false)
    tags                         = optional(map(string))
  }))
```

### <a name="input_location"></a> [location](#input\_location)

Description: Azure region where the resource should be deployed.

Type: `string`

### <a name="input_odaa_vnet_peerings"></a> [odaa\_vnet\_peerings](#input\_odaa\_vnet\_peerings)

Description: List of virtual network peerings to be setup

Type:

```hcl
map(object({
    vnet_source_resource_group      = string
    vnet_destination_resource_group = string
    vnet_source_name                = string
    vnet_destination_name           = string
    }
  ))
```

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: The resource group where the resources will be deployed.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_customer_managed_key"></a> [customer\_managed\_key](#input\_customer\_managed\_key)

Description: A map describing customer-managed keys to associate with the resource. This includes the following properties:
- `key_vault_resource_id` - The resource ID of the Key Vault where the key is stored.
- `key_name` - The name of the key.
- `key_version` - (Optional) The version of the key. If not specified, the latest version is used.
- `user_assigned_identity` - (Optional) An object representing a user-assigned identity with the following properties:
  - `resource_id` - The resource ID of the user-assigned identity.

Type:

```hcl
object({
    key_vault_resource_id = string
    key_name              = string
    key_version           = optional(string, null)
    user_assigned_identity = optional(object({
      resource_id = string
    }), null)
  })
```

Default: `null`

### <a name="input_diagnostic_settings"></a> [diagnostic\_settings](#input\_diagnostic\_settings)

Description: A map of diagnostic settings to create on the Key Vault. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

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

Type:

```hcl
map(object({
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
```

Default: `{}`

### <a name="input_enable_telemetry"></a> [enable\_telemetry](#input\_enable\_telemetry)

Description: This variable controls whether or not telemetry is enabled for the module.  
For more information see <https://aka.ms/avm/telemetryinfo>.  
If it is set to false, then no telemetry will be collected.

Type: `bool`

Default: `true`

### <a name="input_lock"></a> [lock](#input\_lock)

Description: Controls the Resource Lock configuration for this resource. The following properties can be specified:

- `kind` - (Required) The type of lock. Possible values are `\"CanNotDelete\"` and `\"ReadOnly\"`.
- `name` - (Optional) The name of the lock. If not specified, a name will be generated based on the `kind` value. Changing this forces the creation of a new resource.

Type:

```hcl
object({
    kind = string
    name = optional(string, null)
  })
```

Default: `null`

### <a name="input_managed_identities"></a> [managed\_identities](#input\_managed\_identities)

Description: Controls the Managed Identity configuration on this resource. The following properties can be specified:

- `system_assigned` - (Optional) Specifies if the System Assigned Managed Identity should be enabled.
- `user_assigned_resource_ids` - (Optional) Specifies a list of User Assigned Managed Identity resource IDs to be assigned to this resource.

Type:

```hcl
object({
    system_assigned            = optional(bool, false)
    user_assigned_resource_ids = optional(set(string), [])
  })
```

Default: `{}`

### <a name="input_private_endpoints"></a> [private\_endpoints](#input\_private\_endpoints)

Description: A map of private endpoints to create on this resource. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

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

Type:

```hcl
map(object({
    name = optional(string, null)
    role_assignments = optional(map(object({
      role_definition_id_or_name             = string
      principal_id                           = string
      description                            = optional(string, null)
      skip_service_principal_aad_check       = optional(bool, false)
      condition                              = optional(string, null)
      condition_version                      = optional(string, null)
      delegated_managed_identity_resource_id = optional(string, null)
      principal_type                         = optional(string, null)
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
```

Default: `{}`

### <a name="input_private_endpoints_manage_dns_zone_group"></a> [private\_endpoints\_manage\_dns\_zone\_group](#input\_private\_endpoints\_manage\_dns\_zone\_group)

Description: Whether to manage private DNS zone groups with this module. If set to false, you must manage private DNS zone groups externally, e.g. using Azure Policy.

Type: `bool`

Default: `true`

### <a name="input_role_assignments"></a> [role\_assignments](#input\_role\_assignments)

Description: A map of role assignments to create on this resource. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `role_definition_id_or_name` - The ID or name of the role definition to assign to the principal.
- `principal_id` - The ID of the principal to assign the role to.
- `description` - The description of the role assignment.
- `skip_service_principal_aad_check` - If set to true, skips the Azure Active Directory check for the service principal in the tenant. Defaults to false.
- `condition` - The condition which will be used to scope the role assignment.
- `condition_version` - The version of the condition syntax. Valid values are '2.0'.
- `delegated_managed_identity_resource_id` - (Optional) The delegated Azure Resource Id which contains a Managed Identity. Changing this forces a new resource to be created. This field is only used in cross-tenant scenario.
- `principal_type` - (Optional) The type of the `principal_id`. Possible values are `User`, `Group` and `ServicePrincipal`. It is necessary to explicitly set this attribute when creating role assignments if the principal creating the assignment is constrained by ABAC rules that filters on the PrincipalType attribute.

> Note: only set `skip_service_principal_aad_check` to true if you are assigning a role to a service principal.

Type:

```hcl
map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    description                            = optional(string, null)
    skip_service_principal_aad_check       = optional(bool, false)
    condition                              = optional(string, null)
    condition_version                      = optional(string, null)
    delegated_managed_identity_resource_id = optional(string, null)
    principal_type                         = optional(string, null)
  }))
```

Default: `{}`

### <a name="input_route_tables"></a> [route\_tables](#input\_route\_tables)

Description: Route tables for Exadata appliance vnets/subnets

Type:

```hcl
map(object({
    name                          = string
    disable_bgp_route_propagation = optional(bool, null)
    route = optional(set(object({
      address_prefix         = string
      name                   = string
      next_hop_in_ip_address = string
      next_hop_type          = string
    })), null)
  }))
```

Default: `{}`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: (Optional) Tags of the resource.

Type: `map(string)`

Default: `null`

### <a name="input_virtual_networks"></a> [virtual\_networks](#input\_virtual\_networks)

Description: Virtual Network(s) for hosting Exadata appliances

Type:

```hcl
map(object({
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
```

Default:

```json
{
  "primaryvnet": {
    "address_space": [
      "10.0.0.0/16"
    ],
    "name": "vnet-odaa",
    "subnet": [
      {
        "address_prefixes": [
          "10.0.0.0/24"
        ],
        "associate_route_table": false,
        "delegate_to_oracle": true,
        "name": "client"
      },
      {
        "address_prefixes": [
          "10.0.1.0/24"
        ],
        "associate_route_table": false,
        "delegate_to_oracle": false,
        "name": "backup"
      }
    ]
  }
}
```

## Outputs

The following outputs are exported:

### <a name="output_odaa_infra_resource_ids"></a> [odaa\_infra\_resource\_ids](#output\_odaa\_infra\_resource\_ids)

Description: Resource IDs of the ODAA Infrastructure resources created.

### <a name="output_odaa_vmcluster_resource_ids"></a> [odaa\_vmcluster\_resource\_ids](#output\_odaa\_vmcluster\_resource\_ids)

Description: Resource IDs of the ODAA VM Cluster resources created.

### <a name="output_odaa_vnets_resource_ids"></a> [odaa\_vnets\_resource\_ids](#output\_odaa\_vnets\_resource\_ids)

Description: Resource IDs of the Virtual networks created

### <a name="output_resource_id"></a> [resource\_id](#output\_resource\_id)

Description: Resource ID for tflint compliance

## Modules

The following Modules are called:

### <a name="module_odaa_infrastructure"></a> [odaa\_infrastructure](#module\_odaa\_infrastructure)

Source: Azure/avm-res-oracledatabase-cloudexadatainfrastructure/azurerm

Version: 0.1.0

### <a name="module_odaa_vmcluster"></a> [odaa\_vmcluster](#module\_odaa\_vmcluster)

Source: Azure/avm-res-oracledatabase-cloudvmcluster/azurerm

Version: 0.1.0

### <a name="module_odaa_vnets"></a> [odaa\_vnets](#module\_odaa\_vnets)

Source: Azure/avm-res-network-virtualnetwork/azurerm

Version: 0.1.4

### <a name="module_vnet_peerings"></a> [vnet\_peerings](#module\_vnet\_peerings)

Source: ./modules/vnet_peerings

Version:

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->