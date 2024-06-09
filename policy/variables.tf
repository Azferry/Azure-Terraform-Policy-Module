variable "archetypes" {
  type        = map(any)
  description = "A map of configuration overrides for the archetype module"
}

variable "base_scope_id" {
  type        = string
  description = "The base scope ID for the governance module"

}

variable "scope_id" {
  type        = string
  description = "The base scope ID for the governance module"

}
variable "root_id" {
  type        = string
  description = "If specified, will set a custom Name (ID) value for the Enterprise-scale \"root\" Management Group, and append this to the ID for all core Enterprise-scale Management Groups."
  default     = "es"

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{2,10}$", var.root_id))
    error_message = "Value must be between 2 to 10 characters long, consisting of alphanumeric characters and hyphens."
  }
}

variable "root_parent_id" {
  type        = string
  description = "The root_parent_id is used to specify where to set the root for all Landing Zone deployments. Usually the Tenant ID when deploying the core Enterprise-scale Landing Zones."
  validation {
    condition     = can(regex("^[a-zA-Z0-9-_\\(\\)\\.]{1,36}$", var.root_parent_id))
    error_message = "Value must be a valid Management Group ID, consisting of alphanumeric characters, hyphens, underscores, periods and parentheses."
  }
}

variable "default_location" {
  type        = string
  description = "If specified, will set the Azure region in which region bound resources will be deployed. Please see: https://azure.microsoft.com/en-gb/global-infrastructure/geographies/"
  default     = "eastus2"
}

variable "subscription_id_management" {
  type        = string
  description = "If specified, identifies the Platform subscription for \"Management\" for resource deployment and correct placement in the Management Group hierarchy."
  default     = "00000000-0000-0000-0000-000000000000"

  validation {
    condition     = can(regex("^[a-z0-9-]{36}$", var.subscription_id_management)) || var.subscription_id_management == ""
    error_message = "Value must be a valid Subscription ID (GUID)."
  }
}

variable "custom_policy_assignments_from_json" {
  type        = list(any)
  description = "A list of custom archetype definitions to be used in place of the built-in definitions."
}

variable "custom_library_path" {
  type        = string
  description = "If specified, will set the path to the custom library of policy definitions and assignments."

}