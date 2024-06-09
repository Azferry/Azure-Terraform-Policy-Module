
# # If Policy Definitions are specified in the archetype definition, generate a list of all Policy Definition files from the built-in and custom library locations
locals {
  builtin_policy_definitions_from_json = tolist(fileset(local.builtin_library_path, "**/policy_definition_*.{json,json.tftpl}"))
}

# If Policy Definition files exist, load content into dataset
locals {
  builtin_policy_definitions_dataset_from_json = try(length(local.builtin_policy_definitions_from_json) > 0, false) ? {
    for filepath in local.builtin_policy_definitions_from_json :
    filepath => jsondecode(templatefile("${local.builtin_library_path}/${filepath}", local.template_file_vars))
  } : null
}

# If Policy Definition datasets exist, convert to map
locals {
  builtin_policy_definitions_map_from_json = try(length(local.builtin_policy_definitions_dataset_from_json) > 0, false) ? {
    for key, value in local.builtin_policy_definitions_dataset_from_json :
    value.name => value
    # if value.type == local.resource_types.policy_definition
  } : null
}


# Extract the desired Policy Definitions from archetype_policy_definitions_map.
locals {
    
  archetype_policy_definitions_output = [
    for policy in local.archetype_policy_definitions :
    {
    #   resource_id = "${local.provider_path.policy_definition}${policy}"
    #   scope_id    = "/providers/Microsoft.Management/managementGroups/${local.scope_id}"
      scope_id = "${local.provider_path.management_groups}${local.scope_id}"
      template    = try(local.builtin_policy_definitions_map_from_json[policy], null)
    }
  ]
}

# convert the output to a map
locals {
  archetype_policy_definitions_output_map = {
    for policy in local.archetype_policy_definitions_output :
    policy.template.name => policy
  }
}