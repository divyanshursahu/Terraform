/*

The following links provide the documentation for the new blocks used
in this terraform configuration file

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
      https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network
*/

resource "azurerm_virtual_network" "az-vnet" {
  name = "az-vnet"
  resource_group_name = azurerm_resource_group.app-grp.name
  location = azurerm_resource_group.app-grp.location
  address_space = [ "10.0.0.0/16"]

  ## You can just create VNET Only also

/*   subnets can be also created with a seperate resource blocks

  subnet  {
    name = "SubnetA"
    address_prefix = "10.0.0.0/24"
    }

  subnet {
    name = "SubnetB"
    address_prefix = "10.0.1.0/24"
  }

  */
}
 

/* 
      This block will create a container in storage account
      -https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container
*/
