
//-------------VMCluster resources ------------
// OperationId: CloudVmClusters_CreateOrUpdate, CloudVmClusters_Get, CloudVmClusters_Delete
// PUT GET DELETE /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Oracle.Database/cloudVmClusters/{cloudvmclustername}
resource "azapi_resource" "odaa_vm_cluster" {
  for_each = var.cloud_exadata_vm_cluster

  type                      = "Oracle.Database/cloudVmClusters@2023-09-01-preview"
  parent_id                 = data.azurerm_resource_group.rg.id
  name                      = each.value.cluster_name
  schema_validation_enabled = false

  timeouts {
    create = "6h30m"
    delete = "20m"
  }

  body = jsonencode({
    "properties" : {
      "dataStorageSizeInTbs" : each.value.data_storage_size_in_tbs,
      "dbNodeStorageSizeInGbs" : each.value.dbnode_storage_size_in_gbs,
      "memorySizeInGbs" : each.value.memory_size_in_gbs,
      "timeZone" : each.value.time_zone,
      "hostname" : each.value.hostname,
      "domain" : each.value.domain,
      "cpuCoreCount" : each.value.cpu_core_count,
      #"ocpuCount" : 3,
      "clusterName" : each.value.cluster_name,
      "dataStoragePercentage" : each.value.data_storage_percentage,
      "isLocalBackupEnabled" : each.value.is_local_backup_enabled,
      "cloudExadataInfrastructureId" : each.value.cloud_exadata_infrastructure_id,
      "isSparseDiskgroupEnabled" : each.value.is_sparse_diskgroup_enabled,
      "sshPublicKeys" : each.value.ssh_public_keys,
      "licenseModel" : each.value.license_model,
      "vnetId" :each.value.vnet_id,
      "giVersion" : each.value.gi_version,
      "subnetId" : each.value.subnet_id,
      "backupSubnetCidr" : each.value.backup_subnet_cidr,
      # "nsgCidrs" : each.value.nsgCidrs,
      "dataCollectionOptions" : {
        "isDiagnosticsEventsEnabled" : each.value.is_diagnostic_events_enabled,
        "isHealthMonitoringEnabled" : each.value.is_health_monitoring_enabled,
        "isIncidentLogsEnabled" : each.value.is_incident_logs_enabled
      },
      "displayName" : each.value.display_name,
      "dbServers": each.value.db_servers
    },
    "location" : var.location
    }
  )
  response_export_values = ["properties.ocid"]
  lifecycle {
    ignore_changes = [
      body.properties.giVersion, body.properties.hostname
    ]
  }

  depends_on = [azapi_resource.odaa_infra]
}
