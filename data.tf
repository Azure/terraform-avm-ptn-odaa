
resource "random_string" "suffix" {
  length  = 5
  upper   = false
  special = false
}

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}


