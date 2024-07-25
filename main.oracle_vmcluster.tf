
# //-------------VMCluster resources ------------
# // OperationId: CloudVmClusters_CreateOrUpdate, CloudVmClusters_Get, CloudVmClusters_Delete
# // PUT GET DELETE /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Oracle.Database/cloudVmClusters/{cloudvmclustername}
# resource "azapi_resource" "odaa_vm_cluster" {


#   type                      = "Oracle.Database/cloudVmClusters@2023-09-01-preview"
#   parent_id                 = azurerm_resource_group.rg.id
#   name                      = local.odaa_vm_cluster_config.cluster_name
#   schema_validation_enabled = false

#   timeouts {
#     create = "1h30m"
#     delete = "20m"
#   }

#   body = jsonencode({
#     "properties" : {
#       "dataStorageSizeInTbs" : local.odaa_vm_cluster_config.data_storage_size_in_tbs,
#       "dbNodeStorageSizeInGbs" : local.odaa_vm_cluster_config.dbnode_storage_size_in_gbs,
#       "memorySizeInGbs" : local.odaa_vm_cluster_config.memory_size_in_gbs,
#       "timeZone" : local.odaa_vm_cluster_config.time_zone,
#       "hostname" : local.odaa_vm_cluster_config.hostname,
#       "domain" : local.odaa_vm_cluster_config.domain,
#       "cpuCoreCount" : local.odaa_vm_cluster_config.cpu_core_count,
#       #"ocpuCount" : 3,
#       "clusterName" : local.odaa_vm_cluster_config.cluster_name,
#       "dataStoragePercentage" : local.odaa_vm_cluster_config.data_storage_percentage,
#       "isLocalBackupEnabled" : local.odaa_vm_cluster_config.is_local_backup_enabled,
#       "cloudExadataInfrastructureId" : "${azapi_resource.odaa_infra.id}",
#       "isSparseDiskgroupEnabled" : local.odaa_vm_cluster_config.is_sparse_diskgroup_enabled,
#       "sshPublicKeys" : [
#         "${azapi_resource.ssh_public_key.id}"
#       ],

#       "nsgCidrs": local.odaa_vm_cluster_config.nsgCidrs,

   
#       "licenseModel" : local.odaa_vm_cluster_config.license_model,
#       #"scanListenerPortTcp" : 1050,
#       #"scanListenerPortTcpSsl" : 1025,
#       "vnetId" : module.odaa_vnets["primaryvnet"].virtual_network_id,
#       "giVersion" : local.odaa_vm_cluster_config.gi_version,
#       "subnetId" : module.odaa_vnets["primaryvnet"].subnets["snet-odaa"].id,
#       #"backupSubnetCidr" : "172.17.5.0/24",
#       "dataCollectionOptions" : {
#         "isDiagnosticsEventsEnabled" : local.odaa_vm_cluster_config.is_diagnostic_events_enabled,
#         "isHealthMonitoringEnabled" : local.odaa_vm_cluster_config.is_health_monitoring_enabled,
#         "isIncidentLogsEnabled" : local.odaa_vm_cluster_config.is_incident_logs_enabled
#       },
#       "displayName" : local.odaa_vm_cluster_config.display_name,
#       # "dbServers" : [
#       #   "ocid1..aaaa"
#       # ]
#     },
#     "location" : var.location
#     }
#   )
#   response_export_values = ["properties.ocid"]
#   depends_on             = [azapi_resource.odaa_infra]
# }
