terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.66.0"
    }
  }
}

provider "azurerm" {
  features {
  }
}

locals {
  azurerm_resource_group = "app-rg"
  location               = "West Europe"
}

resource "azurerm_resource_group" "app-rg" {
  name     = local.azurerm_resource_group
  location = local.location
}

resource "azurerm_storage_account" "appstore566565637" {
  #count                    = 2
  name                     = "appstore566565637"
  resource_group_name      = local.azurerm_resource_group
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  depends_on = [
    azurerm_resource_group.app-rg
  ]
}

resource "azurerm_storage_container" "storage-blob" {
  for_each = toset([ "data", "files" ])
  name = each.key
  storage_account_name = azurerm_storage_account.appstore566565637.name
  container_access_type = "blob"
}
