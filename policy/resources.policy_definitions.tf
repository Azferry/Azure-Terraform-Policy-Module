resource "azurerm_policy_definition" "enterprise_scale" {
  for_each = local.archetype_policy_definitions_output_map

  # Mandatory resource attributes
  # local.builtin_policy_definitions_map_from_json
  name         = each.value.template.name
  policy_type  = "Custom"
  mode         = each.value.template.properties.mode
  display_name = each.value.template.properties.displayName

  # Optional resource attributes
  description         = try(each.value.template.properties.description, "${each.value.template.name} Policy Definition at scope ${each.value.scope_id}")
  management_group_id = try(each.value.scope_id, null)
  policy_rule         = try(length(each.value.template.properties.policyRule) > 0, false) ? jsonencode(each.value.template.properties.policyRule) : null
  metadata            = try(length(each.value.template.properties.metadata) > 0, false) ? jsonencode(each.value.template.properties.metadata) : null
  parameters          = try(length(each.value.template.properties.parameters) > 0, false) ? jsonencode(each.value.template.properties.parameters) : null

  # Set explicit dependency on Management Group deployments
  depends_on = [
    # time_sleep.after_azurerm_management_group,
  ]

}

# /providers/Microsoft.Management/managementGroups/0000000-0000-0000-0000-000000000000

resource "time_sleep" "after_azurerm_policy_definition" {
  depends_on = [
    # time_sleep.after_azurerm_management_group,
    azurerm_policy_definition.enterprise_scale,
  ]

  triggers = {
    "azurerm_policy_definition_enterprise_scale" = jsonencode(keys(azurerm_policy_definition.enterprise_scale))
  }

  create_duration  = local.create_duration_delay["after_azurerm_policy_definition"]
  destroy_duration = local.destroy_duration_delay["after_azurerm_policy_definition"]
}
