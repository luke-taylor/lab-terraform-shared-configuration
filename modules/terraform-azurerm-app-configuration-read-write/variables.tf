variable "app_configuration_store_id" {
  type        = string
  description = "The id of the configuration store."
  validation {
    condition     = length(regexall("^/subscriptions/[^/]+/resourceGroups/[^/]+/providers/Microsoft.AppConfiguration/configurationStores/[^/]+$", var.app_configuration_store_id)) > 0
    error_message = "The configuration store id must be in the format '/subscriptions/<subscription_id>/resourceGroups/<resource_group_name>/providers/Microsoft.AppConfiguration/configurationStores/<configuration_store_name>'."
  }
}

variable "key" {
  type        = string
  description = "The key to write or read in the configuration store. Use * to return all key-values with a particular label."
}

variable "label" {
  type        = string
  description = "The label to write or read in the configuration store."
  default     = null
}

variable "value" {
  type        = any
  default     = null
  description = "The value to write in the configuration store."
}

variable "read_or_write" {
  type        = string
  description = "Whether to read or write the key in the configuration store."

  validation {
    condition     = contains(["read", "write"], var.read_or_write)
    error_message = "The value must be either 'read' or 'write'."
  }
}

variable "tags" {
  type        = map(string)
  description = "The tags to associate with the key in the configuration store."
  default     = {}
  nullable    = false
}
