/*

The following links provide the documentation for the new blocks used
in this terraform configuration file

-https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account

*/

terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "3.66.0"
    }
  }
}

provider "azurerm"{
  features {}
}

/* 
      This block will create a resource group
*/

resource "azurerm_resource_group" "app-grp" {
  name = "app-rg"
  location = "East US"
}

/* 
      This block will create a storage account
      -https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account
*/

resource "azurerm_storage_account" "storageacc3861919" {
 name = "storageacc3861919"
 location =  azurerm_resource_group.app-grp.location
 resource_group_name = azurerm_resource_group.app-grp.name
 account_tier = "Standard"
 account_replication_type = "LRS"
 
}

/* 
      This block will create a container in storage account
      -https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container
*/

resource "azurerm_storage_container" "container" {
  name = "container167"
  storage_account_name = azurerm_storage_account.storageacc3861919.name
  container_access_type = "private" 
}

/* 
      This block will create a blob in storage account conatiner
      -https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_blob
*/

resource "azurerm_storage_blob" "env-file" {
  name = "env_variable.cpgz"
  storage_account_name = azurerm_storage_account.storageacc3861919.name
  storage_container_name = azurerm_storage_container.container.name
  type = "Block"
  source = "env_variable.cpgz" .  #you can add your own file

  # if you dont mention the source this block will create a block with name filed as env_variable.cpgz
}