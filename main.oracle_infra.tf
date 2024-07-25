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
  name      = var.odaa_infra_name

  timeouts {
    create = "1h30m"
    delete = "20m"
  }

  body = jsonencode({
    "location" : var.location,
    "zones" : [
      var.odaa_infra_zone
    ],
    "tags" : {
      "createdby" : local.odaa_infra_config.createdby
    },
    "properties" : {
      "computeCount" : local.odaa_infra_config.compute_count,
      "displayName" : local.odaa_infra_config.display_name,
      "maintenanceWindow" : {
        "leadTimeInWeeks" : local.odaa_infra_config.maintenance_window_leadtime_in_weeks,
        "preference" : local.odaa_infra_config.maintenance_window_preference,
        "patchingMode" : local.odaa_infra_config.maintenance_window_patching_mode
      },
      "shape" : local.odaa_infra_config.shape,
      "storageCount" : local.odaa_infra_config.storage_count,
    }
  })
  schema_validation_enabled = false
}


// OperationId: DbServers_ListByCloudExadataInfrastructure
// GET /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Oracle.Database/cloudExadataInfrastructures/{cloudexadatainfrastructurename}/dbServers
data "azapi_resource_list" "listDbServersByCloudExadataInfrastructure" {
  type                   = "Oracle.Database/cloudExadataInfrastructures/dbServers@2023-09-01-preview"
  parent_id              = azapi_resource.odaa_infra.id
  depends_on             = [azapi_resource.odaa_infra]
  response_export_values = ["*"]
}

