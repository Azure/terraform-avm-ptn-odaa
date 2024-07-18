
//-------------VMCluster resources ------------
// OperationId: CloudVmClusters_CreateOrUpdate, CloudVmClusters_Get, CloudVmClusters_Delete
// PUT GET DELETE /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Oracle.Database/cloudVmClusters/{cloudvmclustername}
resource "azapi_resource" "cloudVmCluster" {


  type                      = "Oracle.Database/cloudVmClusters@2023-09-01-preview"
  parent_id                 = azurerm_resource_group.rg.id
  name                      = "odaa-cluster"
  schema_validation_enabled = false
  
  body = jsonencode({
    "properties" : {
      "dataStorageSizeInTbs" : 1000,
      "dbNodeStorageSizeInGbs" : 1000,
      "memorySizeInGbs" : 1000,
      "timeZone" : "UTC",
      "hostname" : "hostname1",
      "domain" : "domain1",
      "cpuCoreCount" : 2,
      "ocpuCount" : 3,
      "clusterName" : "cluster1",
      "dataStoragePercentage" : 100,
      "isLocalBackupEnabled" : false,
      "cloudExadataInfrastructureId" : "${azapi_resource.odaa_infra.id}",
      "isSparseDiskgroupEnabled" : false,
      "sshPublicKeys" : [
        "ssh-key 1"
      ],
      "nsgCidrs" : [
        {
          "source" : "10.0.0.0/16",
          "destinationPortRange" : {
            "min" : 1520,
            "max" : 1522
          }
        },
        {
          "source" : "10.10.0.0/24"
        }
      ],
      "licenseModel" : "LicenseIncluded",
      "scanListenerPortTcp" : 1050,
      "scanListenerPortTcpSsl" : 1025,
      "vnetId" : "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg000/providers/Microsoft.Network/virtualNetworks/vnet1",
      "giVersion" : "19.0.0.0",
      "subnetId" : "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg000/providers/Microsoft.Network/virtualNetworks/vnet1/subnets/subnet1",
      "backupSubnetCidr" : "172.17.5.0/24",
      "dataCollectionOptions" : {
        "isDiagnosticsEventsEnabled" : false,
        "isHealthMonitoringEnabled" : false,
        "isIncidentLogsEnabled" : false
      },
      "displayName" : "cluster 1",
      "dbServers" : [
        "ocid1..aaaa"
      ]
    },
    "location" : "eastus"
    }
  )
  response_export_values = ["properties.ocid"]
  depends_on                = [azapi_resource.odaa_infra]
}
