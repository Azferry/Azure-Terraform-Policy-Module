
locals {
  module_output = {
    # builtin_policy_definitions_from_json = local.builtin_policy_definitions_from_json
    # builtin_policy_definitions_map_from_json = local.builtin_policy_definitions_map_from_json
    # archetype_policy_definitions_output = local.archetype_policy_definitions_output
    # archetype_policy_set_definitions_output_map = local.archetype_policy_set_definitions_output_map
    archetype_policy_assignments_output = local.archetype_policy_assignments_output
    archetype_policy_assignments_map = local.archetype_policy_assignments_map
    # azurerm_policy_assignment     = local.archetype_policy_assignments_output
    # azurerm_policy_definition     = local.archetype_policy_definitions_output
    # azurerm_policy_set_definition = local.archetype_policy_set_definitions_output
  }
}

output "configuration" {
  value       = local.module_output
  description = "Returns the archetype configuration data used to generate all resources needed to complete deployment of the Enterprise-scale Landing Zones, as per the specified archetype_id."
}