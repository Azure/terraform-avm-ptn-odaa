# TODO: insert locals here.
locals {

  prefix = var.prefix == "" ? random_string.prefix.result : var.prefix
nameprefix="asdaw"

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


   odaa_infra_config = {
    location : var.location,
    name : var.odaa_infra_name,
    zone : var.odaa_infra_zone,
    compute_count : var.odaa_infra_compute_count,

    display_name : var.odaa_infra_display_name == "" ? var.odaa_infra_name : var.odaa_infra_display_name,
    storage_count : var.odaa_infra_storage_count,
    shape : var.odaa_infra_shape,
    maintenance_window_leadtime_in_weeks = var.odaa_infra_maintenance_window_leadtime_in_weeks,
    maintenance_window_preference        = var.odaa_infra_maintenance_window_preference
    maintenance_window_patching_mode     = var.odaa_infra_maintenance_window_patching_mode
    createdby                            = var.odaa_infra_createdby == "" ? tostring(data.azurerm_client_config.current.object_id) : var.odaa_infra_createdby
  }


odaa_vm_cluster_config={
  cluster_name : "${var.odaa_vm_cluster_name}",
  display_name : var.odaa_vm_cluster_name== "" ? "${var.odaa_vm_cluster_name}" : var.odaa_cluster_display_name,
  data_storage_size_in_tbs   = var.odaa_cluster_data_storage_size_in_tbs,
  dbnode_storage_size_in_gbs = var.odaa_cluster_dbnode_storage_size_in_gbs,
  time_zone                  = var.odaa_cluster_time_zone,
  memory_size_in_gbs         = var.odaa_cluster_memory_size_in_gbs,
  hostname : var.odaa_cluster_hostname,
  cpu_core_count : var.odaa_cluster_cpu_core_count,
  data_storage_percentage : var.odaa_cluster_data_storage_percentage,
  is_local_backup_enabled = var.odaa_cluster_is_local_backup_enabled,
  is_sparse_diskgroup_enabled : var.odaa_cluster_is_sparse_diskgroup_enabled,
  license_model : var.odaa_cluster_license_model,
  gi_version : var.odaa_cluster_gi_version,
  is_diagnostic_events_enabled : var.odaa_cluster_is_diagnostic_events_enabled,
  is_health_monitoring_enabled : var.odaa_cluster_is_health_monitoring_enabled,
  is_incident_logs_enabled : var.odaa_cluster_is_incident_logs_enabled,
  backup_subnet_cidr : var.odaa_cluster_backup_subnet_cidr
  domain : var.odaa_cluster_domain, # seems to not be required
  nsg_cidrs: var.odaa_cluster_nsg_cidrs,
  
}

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
