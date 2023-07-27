/*

The following links provide the documentation for the new blocks used
in this terraform configuration file

*/

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.66.0"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  resource_group_name = "app-rg"
  location            = "East us"
  virtual_network = {
    name          = "az-vnet"
    address_space = "10.0.0.0/16"
  }

  subnets = [
    {
      name           = "subnetA"
      address_prefix = "10.0.0.0/24"
    },
    {
      name           = "subnetB"
      address_prefix = "10.0.1.0/24"
    }
  ]
}
/* 
      This block will create a resource group
*/

resource "azurerm_resource_group" "app-grp" {
  name     = local.resource_group_name
  location = local.location
}

/* 
      This block will create a storage account
      https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network
*/

resource "azurerm_virtual_network" "az-vnet" {
  name                = local.virtual_network.name
  resource_group_name = local.resource_group_name
  location            = local.location
  address_space       = [local.virtual_network.address_space]

  ## You can just create VNET Only also

  /*   subnets can be also created with a seperate resource blocks */

  # subnet  {
  #   name = local.subnets[0].name
  #   address_prefix = local.subnets[0].address_prefix
  #   }

  # subnet {
  #   name = local.subnets[1].name
  #   address_prefix = local.subnets[1].address_prefix
  # }  

  depends_on = [azurerm_resource_group.app-grp]
}

resource "azurerm_subnet" "subnetA" {
  name                 = local.subnets[0].name
  address_prefixes     = [local.subnets[0].address_prefix]
  virtual_network_name = local.virtual_network.name
  resource_group_name  = local.resource_group_name

  depends_on = [azurerm_virtual_network.az-vnet]
}

resource "azurerm_subnet" "subnetB" {
  name                 = local.subnets[1].name
  address_prefixes     = [local.subnets[1].address_prefix]
  virtual_network_name = local.virtual_network.name
  resource_group_name  = local.resource_group_name

  depends_on = [azurerm_virtual_network.az-vnet]
}

resource "azurerm_network_interface" "az-nic" {
  name                = "az-nic"
  resource_group_name = local.resource_group_name
  location            = local.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnetB.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.pub-ip.id
  }
  depends_on = [ 
    azurerm_resource_group.app-grp
   ]
}

resource "azurerm_network_interface" "az-nic2" {
  name = "az-nic2"
  resource_group_name = local.resource_group_name
  location = local.location
  ip_configuration {
    name = "internal"
    subnet_id = azurerm_subnet.subnetA.id
    private_ip_address_allocation = "Dynamic"
  }

  depends_on = [ 
    azurerm_resource_group.app-grp
   ]
}

resource "azurerm_public_ip" "pub-ip" {
  name                = "pub-ip"
  resource_group_name = local.resource_group_name
  location            = local.location
  allocation_method   = "Static"

  depends_on = [azurerm_resource_group.app-grp]

}

resource "azurerm_network_security_group" "az-nsg" {
  name                = "az-nsg"
  resource_group_name = local.resource_group_name
  location            = local.location

  security_rule {
    name                       = "AllowRDP"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["3389", "22"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"

  }
  depends_on = [azurerm_resource_group.app-grp]
}

resource "azurerm_subnet_network_security_group_association" "name" {
  subnet_id = azurerm_subnet.subnetB.id
  network_security_group_id = azurerm_network_security_group.az-nsg.id
}

resource "azurerm_windows_virtual_machine" "app-vm" {
  name                  = "app-vm"
  resource_group_name   = local.resource_group_name
  location              = local.location
  size                  = "Standard_B1s"
  admin_username        = "azuser"
  admin_password        = "Deloitte@12930."
  network_interface_ids = [azurerm_network_interface.az-nic.id, ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  depends_on = [
    azurerm_network_interface.az-nic,
    azurerm_resource_group.app-grp
  ]
}


output "subnetA_id" {
  value = azurerm_subnet.subnetA.id

}

output "vnet-name" {
  value = azurerm_virtual_network.az-vnet.name
}

output "subnetB_id" {
  value = azurerm_subnet.subnetB.name
}

output "public-ip" {
  value = azurerm_public_ip.pub-ip.ip_address
}