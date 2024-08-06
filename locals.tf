# TODO: insert locals here.
locals {
  managed_identities = {
    system_assigned_user_assigned = (var.managed_identities.system_assigned || length(var.managed_identities.user_assigned_resource_ids) > 0) ? {
      this = {
        type                       = var.managed_identities.system_assigned && length(var.managed_identities.user_assigned_resource_ids) > 0 ? "SystemAssigned, UserAssigned" : length(var.managed_identities.user_assigned_resource_ids) > 0 ? "UserAssigned" : "SystemAssigned"
        user_assigned_resource_ids = var.managed_identities.user_assigned_resource_ids
      }
    } : {}
    system_assigned = var.managed_identities.system_assigned ? {
      this = {
        type = "SystemAssigned"
      }
    } : {}
    user_assigned = length(var.managed_identities.user_assigned_resource_ids) > 0 ? {
      this = {
        type                       = "UserAssigned"
        user_assigned_resource_ids = var.managed_identities.user_assigned_resource_ids
      }
    } : {}
  }
  # Private endpoint application security group associations.
  # We merge the nested maps from private endpoints and application security group associations into a single map.
  private_endpoint_application_security_group_associations = { for assoc in flatten([
    for pe_k, pe_v in var.private_endpoints : [
      for asg_k, asg_v in pe_v.application_security_group_associations : {
        asg_key         = asg_k
        pe_key          = pe_k
        asg_resource_id = asg_v
      }
    ]
  ]) : "${assoc.pe_key}-${assoc.asg_key}" => assoc }
  role_definition_resource_substring = "/providers/Microsoft.Authorization/roleDefinitions"


  # vnet_diagnostics = flatten([
  #   for diag in var.diagnostic_settings : [
  #    for vnet in module.odaa_vnets.resource :{
  #     vnet_id = vnet.value.virtual_network_id
  #     vnet_name = vnet.value.name

  #     diag_name=diag.name!=null ? diag.name : "diag-${vnet.value.name}"
  #     diag_config=diag
  #    }
  #   ]

  # ])

  #  vnet_diagnostics = flatten([
  #   for diag in var.diagnostic_settings : [
  #    for vnet_key, vnet_data in module.odaa_vnets :{
  #     vnet_id = vnet_data.virtual_network_id
  #     vnet_name = vnet_data.vnet_resource.name

  #     diag_name=diag.name!=null ? diag.name : "diag-${vnet_data.vnet_resource.name}"
  #     diag_config=diag
  #    }
  #   ]

  # ])

  #   vnet_diagnostic_pairs = flatten([
  #   for vnet_key, vnet_data in module.odaa_vnets : [
  #     for ds_key, ds in var.diagnostic_settings : {
  #       vnet_id                  = vnet_data.virtual_network_id
  #       vnet_name                = vnet_data.vnet_resource.name
  #       diag_name                = ds.name
  #       workspace_resource_id    = ds.workspace_resource_id
  #       log_analytics_destination_type = ds.log_analytics_destination_type
  #       metric_categories        = ds.metric_categories
  #       log_groups               = ds.log_groups
  #     }
  #   ]
  # ])

}
