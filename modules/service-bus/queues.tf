resource "azurerm_servicebus_queue" "queue" {
  name         = var.queue-name
  namespace_id = azurerm_servicebus_namespace.example.id.   # need to give service-bus-namespace-id

  partitioning_enabled = true. # default false
}