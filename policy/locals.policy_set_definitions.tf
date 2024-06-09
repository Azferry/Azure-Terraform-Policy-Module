
# If Policy Set Definitions are specified in the archetype definition, generate a list of all Policy Set Definition files from the built-in and custom library locations
locals {
  builtin_policy_set_definitions_from_json = tolist(fileset(local.builtin_library_path, "**/policy_set_definition_*.{json,json.tftpl}"))
}

# If Policy Set Definition files exist, load content into dataset
locals {
  builtin_policy_set_definitions_dataset_from_json = try(length(local.builtin_policy_set_definitions_from_json) > 0, false) ? {
    for filepath in local.builtin_policy_set_definitions_from_json :
    filepath => jsondecode(templatefile("${local.builtin_library_path}/${filepath}", local.template_file_vars))
  } : null
}

# If Policy Set Definition datasets exist, convert to map
locals {
  builtin_policy_set_definitions_map_from_json = try(length(local.builtin_policy_set_definitions_dataset_from_json) > 0, false) ? {
    for key, value in local.builtin_policy_set_definitions_dataset_from_json :
    value.name => value
    if value.type == local.resource_types.policy_set_definition
  } : null
}


# Extract the desired Policy Set Definitions from archetype_policy_set_definitions_map.
locals {
  archetype_policy_set_definitions_output = [
    for policy_set in local.archetype_policy_set_definitions :
    {
      resource_id = "${local.provider_path.policy_set_definition}${policy_set}"
      scope_id    = "${local.provider_path.management_groups}${local.scope_id}"
      template    = try(local.builtin_policy_set_definitions_map_from_json[policy_set], null)
    }
  ]
}

# convert the output to a map
locals {
  archetype_policy_set_definitions_output_map = {
    for policy in local.archetype_policy_set_definitions_output :
    policy.template.name => policy
  }
}