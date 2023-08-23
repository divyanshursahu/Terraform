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

resource "azurerm_resource_group" "rg" {
  name = var.rgname
  location =var.location
}

resource "azurerm_virtual_network" "vnet" {
  name = var.vnet_name
  location = var.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space = [ 
    "10.0.0.0/16" 
  ]

  dynamic "subnet" {
    for_each = var.subnets
   # iterator = item  # optional

    # content {
    #   name = item.value.name
    #   address_prefix = item.value.address_space
    # }

    content {
      name = subnet.value.name
      address_prefix = subnet.value.address_space
    }
  }
}

