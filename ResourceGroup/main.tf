resource "azurerm_resource_group" "myRG999" {
  name     = "${var.base_name}RG"
  location = var.location
}