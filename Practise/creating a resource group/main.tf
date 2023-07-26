# module "provider" {
#   #source = "./Users/divyanshusahu/Downloads/Github/Terraform/Practise"
#   source = "../provider"
# }

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

resource "azurerm_resource_group" "app-rg" {
  name = "app-rg"
  location = "East US"
}