# The following block of locals are used to avoid using
# empty object types in the code
locals {
  empty_list   = []
  empty_map    = tomap({})
  empty_string = ""
}

# The following locals are used to convert provided input
# variables to locals before use elsewhere in the module
locals {
  root_id = var.root_id
  # root_name                 = var.root_name
  root_parent_id = var.root_parent_id
  # deploy_core_landing_zones = var.deploy_core_landing_zones
  # # deploy_management_resources     = var.deploy_management_resources
  # deploy_identity_resources       = var.deploy_identity_resources
  # # configure_management_resources  = var.configure_management_resources
  # # configure_identity_resources    = var.configure_identity_resources
  # archetype_config_overrides      = var.archetype_config_overrides
  # subscription_id_overrides       = var.subscription_id_overrides
  # subscription_id_connectivity    = var.subscription_id_connectivity
  # subscription_id_identity        = var.subscription_id_identity
  # subscription_id_management      = var.subscription_id_management
  # custom_landing_zones            = var.custom_landing_zones
  # custom_policy_roles             = var.custom_policy_roles
  library_path = var.library_path
  # default_location                = var.default_location
  # default_tags                    = var.default_tags
  # disable_base_module_tags        = var.disable_base_module_tags
  # disable_telemetry               = var.disable_telemetry
  # strict_subscription_association = var.strict_subscription_association
  # management_tags                 = var.management_tags
  # mgmt_resoruce_prefix            = var.mgmt_resoruce_prefix
  template_file_vars = merge(
    var.template_file_variables,
    # module.management_resources.configuration.template_file_variables,
  )
}


# locals {
#   enforcement_mode_default = {
#     enforcement_mode = null
#   }
#   create_object = {
#     add_bool   = true
#     add_string = local.empty_string
#     add_list   = local.empty_list
#     add_map    = local.empty_map
#     add_null   = null
#   }
#   # management_resources_advanced = merge(
#   #   local.create_object,
#   #   coalesce(local.configure_management_resources.advanced, local.empty_map)
#   # )
# }

# /*
# define a set of module tags applied to all resources unless disabled by the 
# input variable "disable_module_tags"
# */
# locals {
#   base_module_tags = {
#     deployedBy = "terraform"
#   }
#   management_resources_tags = merge(
#     local.disable_base_module_tags ? local.empty_map : local.base_module_tags,
#     coalesce(local.management_tags, local.default_tags),
#   )
# }

# /*
# define base Azure provider paths and resource types
# */
# locals {
#   provider_path = {
#     management_groups = "/providers/Microsoft.Management/managementGroups/"
#     role_assignment   = "/providers/Microsoft.Authorization/roleAssignments/"
#   }
#   resource_types = {
#     policy_definition     = "Microsoft.Authorization/policyDefinitions"
#     policy_set_definition = "Microsoft.Authorization/policySetDefinitions"
#   }
# }

# locals {
#   # The regex is designed to consistently split a resource_id into the following capture groups, regardless of resource type:
#   # [0] Resource scope, type substring (e.g. "/providers/Microsoft.Management/managementGroups/")
#   # [1] Resource scope, name substring (e.g. "group1")
#   # [2] Resource, type substring (e.g. "/providers/Microsoft.Authorization/policyAssignments/")
#   # [3] Resource, name substring (e.g. "assignment1")
#   regex_split_resource_id         = "(?i)((?:/[^/]+){0,8}/)?([^/]+)?((?:/[^/]+){3}/)([^/]+)$"
#   regex_scope_is_management_group = "(?i)(/providers/Microsoft.Management/managementGroups/)([^/]+)$"
#   # regex_scope_is_subscription     = "(?i)(/subscriptions/)([^/]+)$"
#   # regex_scope_is_resource_group   = "(?i)(/subscriptions/[^/]+/resourceGroups/)([^/]+)$"
#   # regex_scope_is_resource         = "(?i)(/subscriptions/[^/]+/resourceGroups(?:/[^/]+){4}/)([^/]+)$"
# }



# /*
# control time_sleep delays between resources to reduce transient errors relating to replication delays in Azure
# */
# locals {
#   default_create_duration_delay  = "30s"
#   default_destroy_duration_delay = "0s"
#   create_duration_delay = {
#     after_azurerm_management_group      = lookup(var.create_duration_delay, "azurerm_management_group", local.default_create_duration_delay)
#     after_azurerm_policy_assignment     = lookup(var.create_duration_delay, "azurerm_policy_assignment", local.default_create_duration_delay)
#     after_azurerm_policy_definition     = lookup(var.create_duration_delay, "azurerm_policy_definition", local.default_create_duration_delay)
#     after_azurerm_policy_set_definition = lookup(var.create_duration_delay, "azurerm_policy_set_definition", local.default_create_duration_delay)
#     after_azurerm_role_assignment       = lookup(var.create_duration_delay, "azurerm_role_assignment", local.default_create_duration_delay)
#     after_azurerm_role_definition       = lookup(var.create_duration_delay, "azurerm_role_definition", local.default_create_duration_delay)
#   }
#   destroy_duration_delay = {
#     after_azurerm_management_group      = lookup(var.destroy_duration_delay, "azurerm_management_group", local.default_destroy_duration_delay)
#     after_azurerm_policy_assignment     = lookup(var.destroy_duration_delay, "azurerm_policy_assignment", local.default_destroy_duration_delay)
#     after_azurerm_policy_definition     = lookup(var.destroy_duration_delay, "azurerm_policy_definition", local.default_destroy_duration_delay)
#     after_azurerm_policy_set_definition = lookup(var.destroy_duration_delay, "azurerm_policy_set_definition", local.default_destroy_duration_delay)
#     after_azurerm_role_assignment       = lookup(var.destroy_duration_delay, "azurerm_role_assignment", local.default_destroy_duration_delay)
#     after_azurerm_role_definition       = lookup(var.destroy_duration_delay, "azurerm_role_definition", local.default_destroy_duration_delay)
#   }
# }