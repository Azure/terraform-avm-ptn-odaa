
resource "random_string" "prefix" {
  length  = 5
  upper   = false
  special = false
}

data "azurerm_client_config" "current" {}


