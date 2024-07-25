# TODO: insert locals here.
locals {

  prefix     = var.prefix == "" ? random_string.prefix.result : var.prefix
  nameprefix = "asdaw"


  full_resource_group_name = "${var.resource_group_name}-${local.prefix}"

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






  # default_cloud_exadata_vm_cluster = {
  #   cluster_name : "${var.odaa_vm_cluster_name}-${var.prefix}",
  #   display_name : "${var.odaa_vm_cluster_name}-${var.prefix}",
  #   data_storage_size_in_tbs   = 2
  #   dbnode_storage_size_in_gbs = 120
  #   time_zone                  = "UTC"
  #   memory_size_in_gbs         = 1000,
  #   hostname : tostring("${data.azurerm_client_config.current.object_id}"),
  #   cpu_core_count : 4,
  #   data_storage_percentage : 80,
  #   is_local_backup_enabled = false,
  #   is_sparse_diskgroup_enabled : false,
  #   license_model : "LicenseIncluded",
  #   gi_version : "19.0.0.0",
  #   is_diagnostic_events_enabled : false,
  #   is_health_monitoring_enabled : false,
  #   is_incident_logs_enabled : false,
  #   backup_subnet_cidr : ""
  #   #domain : "domain1", # seems to not be required
  #   #ocpu_count : 3, # seems to not be required
  #   #nsg_cidrs: ????
  #   #backup_subnet_cidr: TEST THIS!
  # }



  # #Assign default values to the variables if not provided
  # cloud_exadata_infrastructure = var.cloud_exadata_infrastructure == {} ? local.default_cloud_exadata_infrastructure : var.cloud_exadata_infrastructure

  # cloud_exadata_vm_cluster = length(var.cloud_exadata_vm_cluster) == 0 ? tomap(
  # merge(var.cloud_exadata_vm_cluster, local.default_cloud_exadata_vm_cluster)) : var.cloud_exadata_vm_cluster
}
