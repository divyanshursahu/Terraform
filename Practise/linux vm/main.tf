terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
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
  location = "West Europer"
}

resource "azurerm_resource_group" "app-rg" {
  name = local.azurerm_resource_group
  location = local.location
}

resource "azurerm_virtual_network" "app-vnet" {
  name = "${local.azurerm_resource_group}-vnet"
  resource_group_name = local.azurerm_resource_group
  location = local.location
  address_space = [ "10.0.0.0/16" ]
}
