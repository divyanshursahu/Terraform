terraform {
  backend "azurerm" {
    resource_group_name = "div-terraform-sf-backend"
    storage_account_name = "terraformsfbackend"
    container_name = "tfstatefile"
    key = "kube.terraform.tfstate"
  }
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.58.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "kubecluster" {
  name = "kubecluster"
  location = "West Europe"
}

resource "azurerm_kubernetes_cluster" "kubecluster" {
  name = "test-kube-cluster"
  location = "West Europe"
  resource_group_name = azurerm_resource_group.kubecluster.name
  dns_prefix = "test-dns"

  default_node_pool {
    name = "default"
    node_count = 1
    vm_size = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
}