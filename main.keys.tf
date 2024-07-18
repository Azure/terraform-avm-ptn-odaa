#replace it for Azure Key Vault
resource "tls_private_key" "generated_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azapi_resource" "ssh_public_key" {
  type      = "Microsoft.Compute/sshPublicKeys@2023-09-01"
  name      = "${var.resource_group_name}_${var.prefix}_key"
  location  = var.location
  parent_id = azurerm_resource_group.rg.id
  body = jsonencode({
    properties = {
      publicKey = "${tls_private_key.generated_ssh_key.public_key_openssh}"
    }
  })
}
