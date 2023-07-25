/*

The following links provide the documentation for the new blocks used
in this terraform configuration file

-https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account

*/

resource "azurerm_resource_group" "app-grp" {
  name = "app-rg"
  location = "East US"
}
resource "azurerm_storage_account" "storageacc3861919" {
 name = "storageacc3861919"
 location =  azurerm_resource_group.app-grp.location
 resource_group_name = azurerm_resource_group.app-grp.name
 access_tier = "Standard"
 account_replication_type = "LRS"
 
}