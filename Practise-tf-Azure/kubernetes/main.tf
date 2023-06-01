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