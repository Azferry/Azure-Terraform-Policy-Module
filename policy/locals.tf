
/*
avoid using empty object types in the code
*/
locals {
  empty_list   = []
  empty_map    = {}
  empty_string = ""
}

/*
convert basic input variables to locals before use elsewhere in the module.
*/
locals {
  root_id                 = var.root_id
  scope_id                = var.scope_id
  # archetype_id            = var.archetype_id
  # parameters              = var.parameters
  enforcement_mode        = null # var.enforcement_mode
  # access_control          = var.access_control
  # library_path            = var.library_path
  # template_file_variables = var.template_file_variables
  custom_library_path = var.custom_library_path
  default_location        = var.default_location
  sub_id_management       = var.subscription_id_management
  # mgmt_resoruce_prefix = var.mgmt_resoruce_prefix
#   custom_policy_assignments_from_json = var.custom_policy_assignments_from_json
}

locals {
  policy_assignments = var.archetypes.policy_assignments
  policy_definitions = var.archetypes.policy_definitions
}


/*
define the built-in library path, and determine whether a custom library path has been
provided to enable conditional logic on loading configuration files from the library path(s).
*/
locals {
  builtin_library_path          = "${path.module}/lib"
#   custom_library_path_specified = try(length(local.library_path) > 0, false)
#   custom_library_path           = local.custom_library_path_specified ? replace(local.library_path, "//$/", local.empty_string) : null
}

/*
define base Azure provider paths and resource types
*/
locals {
  # scope_is_management_group = length(regexall("^/providers/Microsoft.Management/managementGroups/.*", local.scope_id)) > 0
  # scope_is_subscription     = length(regexall("^/subscriptions/.*", local.scope_id)) > 0
  resource_types = {
    policy_assignment     = "Microsoft.Authorization/policyAssignments"
    policy_definition     = "Microsoft.Authorization/policyDefinitions"
    policy_set_definition = "Microsoft.Authorization/policySetDefinitions"
    role_assignment       = "Microsoft.Authorization/roleAssignments"
    role_definition       = "Microsoft.Authorization/roleDefinitions"
  }
  provider_path = {
    management_groups = "/providers/Microsoft.Management/managementGroups/"
    policy_assignment     = "${local.scope_id}/providers/Microsoft.Authorization/policyAssignments/"
    policy_definition     = "${local.scope_id}/providers/Microsoft.Authorization/policyDefinitions/"
    policy_set_definition = "${local.scope_id}/providers/Microsoft.Authorization/policySetDefinitions/"
    role_assignment       = "${local.scope_id}/providers/Microsoft.Authorization/roleAssignments/"
    role_definition       = "/providers/Microsoft.Authorization/roleDefinitions/"
  }
}

# /*
# used in template functions to provide values
# */
locals {
  core_template_file_variables = {
    root_scope_id              = basename(local.root_id)
    root_scope_resource_id     = local.root_id
#     current_scope_id           = basename(local.scope_id)
    current_scope_resource_id  = local.scope_id
    default_location           = local.default_location
#     location                   = local.default_location
#     builtin                    = local.builtin_library_path
    builtin_library_path       = local.builtin_library_path
#     custom                     = local.custom_library_path
#     custom_library_path        = local.custom_library_path
#     subscription_id_management = local.sub_id_management
#     management_resource_prefix = local.mgmt_resoruce_prefix
    log_analytics_workspace_id = "/subscriptions/${local.sub_id_management}/resourcegroups/rg01/providers/Microsoft.OperationalInsights/workspaces/wasd-la01"
  }
  template_file_vars = merge(
    # local.template_file_variables,
    local.core_template_file_variables,
  )
  archetypes = var.archetypes

  archetype_policy_definitions = var.archetypes.policy_definitions
  archetype_policy_assignments = var.archetypes.policy_assignments
#   archetype_policy_assignments_list = var.archetypes.policy_assignments_list
  archetype_policy_set_definitions = var.archetypes.policy_set_definitions

  base_scope_id = var.base_scope_id

}


/*
control time_sleep delays between resources to reduce transient errors relating to replication delays in Azure
*/
locals {
  default_create_duration_delay  = "30s"
  default_destroy_duration_delay = "0s"
  create_duration_delay = {
    after_azurerm_management_group      = local.default_create_duration_delay
    after_azurerm_policy_assignment     = local.default_create_duration_delay
    after_azurerm_policy_definition     = local.default_create_duration_delay
    after_azurerm_policy_set_definition = local.default_create_duration_delay
  }
  destroy_duration_delay = {
    after_azurerm_management_group      = local.default_destroy_duration_delay
    after_azurerm_policy_assignment     = local.default_destroy_duration_delay
    after_azurerm_policy_definition     = local.default_destroy_duration_delay
    after_azurerm_policy_set_definition = local.default_destroy_duration_delay
  }
}