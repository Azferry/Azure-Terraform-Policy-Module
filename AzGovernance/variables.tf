/*
Management Group Structure
*/
variable "root_parent_id" {
  type        = string
  description = "The root_parent_id is used to specify where to set the root for all Landing Zone deployments. Usually the Tenant ID when deploying the core Enterprise-scale Landing Zones."
  default     = "00000000-0000-0000-0000-000000000000"
  validation {
    condition     = can(regex("^[a-zA-Z0-9-_\\(\\)\\.]{1,36}$", var.root_parent_id))
    error_message = "Value must be a valid Management Group ID, consisting of alphanumeric characters, hyphens, underscores, periods and parentheses."
  }
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

variable "root_name" {
  type        = string
  description = "If specified, will set a custom Display Name value for the Enterprise-scale \"root\" Management Group."
  default     = "es"

  validation {
    condition     = can(regex("^[A-Za-z][A-Za-z0-9- ._]{1,22}[A-Za-z0-9]?$", var.root_name))
    error_message = "Value must be between 2 to 24 characters long, start with a letter, end with a letter or number, and can only contain space, hyphen, underscore or period characters."
  }
}

variable "mgmt_resoruce_prefix" {
  type        = string
  description = "Prefix for resources in the management "
  default     = "ntc-temp"

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{2,20}$", var.mgmt_resoruce_prefix))
    error_message = "Value must be between 2 to 10 characters long, consisting of alphanumeric characters and hyphens."
  }
}

variable "deploy_core_landing_zones" {
  type        = bool
  description = "If set to true, module will deploy the core Enterprise-scale Management Group hierarchy, including \"out of the box\" policies and roles."
  default     = true
}

/*
Management resources
*/

variable "management_tags" {
  type        = map(any)
  description = "Tags placed on resource group"
  default     = {}
}

variable "deploy_identity_resources" {
  type        = bool
  description = "If set to true, will enable the \"Identity\" landing zone settings."
  default     = false
}

variable "archetype_config_overrides" {
  type        = any
  description = "If specified, will set custom Archetype configurations to the default Enterprise-scale Management Groups."
  default     = {}
}

variable "subscription_id_overrides" {
  type        = map(list(string))
  description = "If specified, will be used to assign subscription_ids to the default Enterprise-scale Management Groups."
  default     = {}
}

variable "subscription_id_connectivity" {
  type        = string
  description = "If specified, identifies the Platform subscription for \"Connectivity\" for resource deployment and correct placement in the Management Group hierarchy."
  default     = ""

  validation {
    condition     = can(regex("^[a-z0-9-]{36}$", var.subscription_id_connectivity)) || var.subscription_id_connectivity == ""
    error_message = "Value must be a valid Subscription ID (GUID)."
  }
}

variable "subscription_id_identity" {
  type        = string
  description = "If specified, identifies the Platform subscription for \"Identity\" for resource deployment and correct placement in the Management Group hierarchy."
  default     = ""

  validation {
    condition     = can(regex("^[a-z0-9-]{36}$", var.subscription_id_identity)) || var.subscription_id_identity == ""
    error_message = "Value must be a valid Subscription ID (GUID)."
  }
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

variable "custom_landing_zones" {
  type        = any
  description = "If specified, will deploy additional Management Groups alongside Enterprise-scale core Management Groups."
  default     = {}

  validation {
    condition     = can([for k in keys(var.custom_landing_zones) : regex("^[a-zA-Z0-9-]{2,36}$", k)]) || length(keys(var.custom_landing_zones)) == 0
    error_message = "The custom_landing_zones keys must be between 2 to 36 characters long and can only contain lowercase letters, numbers and hyphens."
  }
}

variable "library_path" {
  type        = string
  description = "If specified, sets the path to a custom library folder for archetype artefacts."
  default     = ""
}

variable "template_file_variables" {
  type        = any
  description = "If specified, provides the ability to define custom template variables used when reading in template files from the built-in and custom library_path."
  default     = {}
}

variable "default_location" {
  type        = string
  description = "If specified, will set the Azure region in which region bound resources will be deployed. Please see: https://azure.microsoft.com/en-gb/global-infrastructure/geographies/"
  default     = "eastus2"
}

variable "default_tags" {
  type        = map(string)
  description = "If specified, will set the default tags for all resources deployed by this module where supported."
  default     = {}
}

variable "disable_base_module_tags" {
  type        = bool
  description = "If set to true, will remove the base module tags applied to all resources deployed by the module which support tags."
  default     = false
}

variable "create_duration_delay" {
  type        = map(string)
  description = "Used to tune terraform apply when faced with errors caused by API caching or eventual consistency. Sets a custom delay period after creation of the specified resource type."
  default = {
    azurerm_management_group      = "30s"
    azurerm_policy_assignment     = "30s"
    azurerm_policy_definition     = "30s"
    azurerm_policy_set_definition = "30s"
    azurerm_role_assignment       = "0s"
    azurerm_role_definition       = "60s"
  }

  validation {
    condition     = can([for v in values(var.create_duration_delay) : regex("^[0-9]{1,6}(s|m|h)$", v)])
    error_message = "The create_duration_delay values must be a string containing the duration in numbers (1-6 digits) followed by the measure of time represented by s (seconds), m (minutes), or h (hours)."
  }
}

variable "destroy_duration_delay" {
  type        = map(string)
  description = "Used to tune terraform deploy when faced with errors caused by API caching or eventual consistency. Sets a custom delay period after destruction of the specified resource type."
  default = {
    azurerm_management_group      = "0s"
    azurerm_policy_assignment     = "0s"
    azurerm_policy_definition     = "0s"
    azurerm_policy_set_definition = "0s"
    azurerm_role_assignment       = "0s"
    azurerm_role_definition       = "0s"
  }

  validation {
    condition     = can([for v in values(var.destroy_duration_delay) : regex("^[0-9]{1,6}(s|m|h)$", v)])
    error_message = "The destroy_duration_delay values must be a string containing the duration in numbers (1-6 digits) followed by the measure of time represented by s (seconds), m (minutes), or h (hours)."
  }
}

variable "custom_policy_roles" {
  type        = map(list(string))
  description = "If specified, the custom_policy_roles variable overrides which Role Definition ID(s) (value) to assign for Policy Assignments with a Managed Identity, if the assigned \"policyDefinitionId\" (key) is included in this variable."
  default     = {}
}

variable "disable_telemetry" {
  type        = bool
  description = "If set to true, will disable telemetry for the module. See https://aka.ms/alz-terraform-module-telemetry."
  default     = false
}

variable "strict_subscription_association" {
  type        = bool
  description = "If set to true, subscriptions associated to management groups will be exclusively set by the module and any added by another process will be removed. If set to false, the module will will only enforce association of the specified subscriptions and those added to management groups by other processes will not be removed."
  default     = true
}
