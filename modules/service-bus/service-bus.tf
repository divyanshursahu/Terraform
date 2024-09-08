resource "azurerm_servicebus_namespace" "example" {
  name                = var.sb-name
  location            = var.location
  resource_group_name = var.rg-name
  sku                 = var.sku

}