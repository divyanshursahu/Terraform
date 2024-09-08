resource "azurerm_container_group" "example" {
  name                = "example-continst12314415"
  location            = "central us"
  resource_group_name = "terraform-servicebus"
  ip_address_type     = "Public"
  dns_name_label      = "aci-label131415512"
  os_type             = "Linux"

  container {
    name   = "hello-world"
    image  = "mcr.microsoft.com/azuredocs/aci-helloworld:latest"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 443
      protocol = "TCP"
    }
  }

  container {
    name   = "sidecar"
    image  = "mcr.microsoft.com/azuredocs/aci-tutorial-sidecar"
    cpu    = "0.5"
    memory = "1.5"
  }

  tags = {
    environment = "testing"
  }
}