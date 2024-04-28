output "value" {
  value       = try(jsondecode(data.azurerm_app_configuration_key.this[0].value), null)
  description = "The value of the key in the configuration store."
}

output "key_values" {
  value = try(
    { for item in data.azurerm_app_configuration_keys.this[0].items :
      (item.key) => jsondecode(item.value)
    },
    null
  )
  description = "The values of the keys in the configuration store."
}
