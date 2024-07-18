resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_name}-${var.prefix}"
  location = var.location
  tags     = var.tags
}


// OperationId: CloudExadataInfrastructures_CreateOrUpdate, CloudExadataInfrastructures_Get, CloudExadataInfrastructures_Delete
// PUT /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Oracle.Database/cloudExadataInfrastructures/{cloudexadatainfrastructurename}
resource "azapi_resource" "odaa_infra" {

  type      = "Oracle.Database/cloudExadataInfrastructures@2023-09-01-preview"
  parent_id = azurerm_resource_group.rg.id
  name      = "odaa-infra"

  timeouts {
    create = "1h30m"
    delete = "20m"
  }

  body = jsonencode({
    "location" : var.cloud_exadata_infrastructure.location,
    "zones" : [
      var.cloud_exadata_infrastructure.zone
    ],
    "tags" : {
      "createdby" : var.cloud_exadata_infrastructure.createdby
    },
    "properties" : {
      "computeCount" : var.cloud_exadata_infrastructure.compute_count,
      "displayName" : var.cloud_exadata_infrastructure.display_name,
      "maintenanceWindow" : {
        "leadTimeInWeeks" : var.cloud_exadata_infrastructure.maintenance_window_loadtime_in_weeks,
        "preference" : var.cloud_exadata_infrastructure.maintenance_window_preference,
        "patchingMode" : var.cloud_exadata_infrastructure.maintenance_window_patching_mode
      },
      "shape" : var.cloud_exadata_infrastructure.shape,
      "storageCount" : var.cloud_exadata_infrastructure.storage_count
    }
  })
  schema_validation_enabled = false
}


