output "app_configuration_store_id" {
  value       = azurerm_app_configuration.this.id
  description = "The id of the configuration store."
}
