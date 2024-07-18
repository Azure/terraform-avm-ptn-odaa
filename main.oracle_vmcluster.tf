
//-------------VMCluster resources ------------
// OperationId: CloudVmClusters_CreateOrUpdate, CloudVmClusters_Get, CloudVmClusters_Delete
// PUT GET DELETE /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Oracle.Database/cloudVmClusters/{cloudvmclustername}
resource "azapi_resource" "cloudVmCluster" {


  type                      = "Oracle.Database/cloudVmClusters@2023-09-01-preview"
  parent_id                 = azurerm_resource_group.rg.id
  name                      = "odaa-cluster-${local.prefix}"
  schema_validation_enabled = false

  timeouts {
    create = "1h30m"
    delete = "20m"
  }

  body = jsonencode({
    "properties" : {
      "dataStorageSizeInTbs" : var.cloud_exadata_vm_cluster.data_storage_size_in_tbs,
      "dbNodeStorageSizeInGbs" : var.cloud_exadata_vm_cluster.dbnode_storage_size_in_gbs,
      "memorySizeInGbs" : var.cloud_exadata_vm_cluster.memory_size_in_gbs,
      "timeZone" : var.cloud_exadata_vm_cluster.time_zone,
      "hostname" : var.cloud_exadata_vm_cluster.hostname,
      #"domain" : "domain1",
      "cpuCoreCount" : var.cloud_exadata_vm_cluster.cpu_core_count,
      #"ocpuCount" : 3,
      "clusterName" : var.cloud_exadata_vm_cluster.name,
      "dataStoragePercentage" : var.cloud_exadata_vm_cluster.data_storage_percentage,
      "isLocalBackupEnabled" : var.cloud_exadata_vm_cluster.is_local_backup_enabled,
      "cloudExadataInfrastructureId" : "${azapi_resource.odaa_infra.id}",
      "isSparseDiskgroupEnabled" : var.cloud_exadata_vm_cluster.is_sparse_diskgroup_enabled,
      "sshPublicKeys" : [
        var.cloud_exadata_vm_cluster.ssh_public_keys
      ],
      # "nsgCidrs" : [
      #   {
      #     "source" : "10.0.0.0/16",
      #     "destinationPortRange" : {
      #       "min" : 1520,
      #       "max" : 1522
      #     }
      #   },
      #   {
      #     "source" : "10.10.0.0/24"
      #   }
      # ],
      "licenseModel" : var.cloud_exadata_vm_cluster.license_model,
      #"scanListenerPortTcp" : 1050,
      #"scanListenerPortTcpSsl" : 1025,
      "vnetId" : var.cloud_exadata_vm_cluster.vnet_id,
      "giVersion" : var.cloud_exadata_vm_cluster.gi_version,
      "subnetId" : var.cloud_exadata_vm_cluster.subnet_id,
      #"backupSubnetCidr" : "172.17.5.0/24",
      "dataCollectionOptions" : {
        "isDiagnosticsEventsEnabled" : var.cloud_exadata_vm_cluster.is_diagnostic_events_enabled,
        "isHealthMonitoringEnabled" : var.cloud_exadata_vm_cluster.is_health_monitoring_enabled,
        "isIncidentLogsEnabled" : var.cloud_exadata_vm_cluster.is_incident_logs_enabled
      },
      "displayName" : var.cloud_exadata_vm_cluster.display_name,
      # "dbServers" : [
      #   "ocid1..aaaa"
      # ]
    },
    "location" : var.location
    }
  )
  response_export_values = ["properties.ocid"]
  depends_on             = [azapi_resource.odaa_infra]
}
