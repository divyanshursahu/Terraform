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
  subnets = {
    name = "subnetA"
    address_space = "10.0.0.0/24" }
}

resource "azurerm_resource_group" "app-rg" {
  name     = local.azurerm_resource_group
  location = local.location
}

resource "azurerm_virtual_network" "app-vnet" {
  name                = "${local.azurerm_resource_group}-vnet"
  resource_group_name = local.azurerm_resource_group
  location            = local.location
  address_space       = ["10.0.0.0/16"]

  depends_on = [
    azurerm_resource_group.app-rg
  ]
}

resource "azurerm_subnet" "app-subnet" {
  name                 = local.subnets.name
  resource_group_name  = local.azurerm_resource_group
  virtual_network_name = azurerm_virtual_network.app-vnet.name
  address_prefixes = [ local.subnets.address_space ]

  depends_on = [
    azurerm_resource_group.app-rg,
    azurerm_virtual_network.app-vnet
  ]
}

resource "azurerm_network_interface" "vm-nic" {
  name                = "vm-nic"
  resource_group_name = local.azurerm_resource_group
  location            = local.location

  ip_configuration {
    name                          = "private-ip"
    subnet_id                     = azurerm_subnet.app-subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  depends_on = [
    azurerm_resource_group.app-rg
  ]

}

resource "azurerm_network_security_group" "az-nsg" {
  name                = "az-nsg"
  resource_group_name = local.azurerm_resource_group
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
  depends_on = [
    azurerm_resource_group.app-rg
  ]
}

resource "azurerm_subnet_network_security_group_association" "asso" {
  network_security_group_id = azurerm_network_security_group.az-nsg.id
  subnet_id                 = azurerm_subnet.app-subnet.id
}

resource "tls_private_key" "pkey" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "local_file" "pkey-file" {
  filename = "private_key.pem"
  content = tls_private_key.pkey.private_key_pem
}

resource "azurerm_linux_virtual_machine" "app-vm" {
  name                = "${local.azurerm_resource_group}-vm"
  resource_group_name = local.azurerm_resource_group
  location            = local.location
  size                = "Standard F2"
  admin_username      = "azuser"
  network_interface_ids = [
    azurerm_network_interface.vm-nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}