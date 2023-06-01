provider "azurerm" {
  features {}
}
resource "azurerm_storage_account" "sa36874hjh38223" {
  name                     = "sa36874hjh38223"
  resource_group_name      = "app-grp"
  location                 = "West Europe"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind = "StorageV2"
}