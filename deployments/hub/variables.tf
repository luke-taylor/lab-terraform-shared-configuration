variable "firewall_enabled" {
  type        = bool
  description = "Whether to create the firewall."
  default     = false
}

variable "bastion_enabled" {
  type        = bool
  description = "Whether to create the bastion."
  default     = false
}

variable "app_configuration_store_id" {
  type        = string
  description = "The name of the configuration store."
}
