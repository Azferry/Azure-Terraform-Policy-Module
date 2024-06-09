
module "az_governance" {
  source     = "../policy"
  for_each   = local.builtin_archetype_definitions_map_from_json
  archetypes = each.value

  root_id        = "es"
  base_scope_id  = "/providers/Microsoft.Management/managementGroups/e2e35a18-aded-4263-b8a5-8f37302a3837"
  scope_id       = each.key
  root_parent_id = local.root_parent_id
  # archetype_id               = var.archetype_id
  # parameters                 = var.parameters
  # access_control             = var.access_control
  # library_path               = var.library_path
  # template_file_variables    = var.template_file_variables
  default_location                    = var.default_location
  subscription_id_management          = var.subscription_id_management
  custom_policy_assignments_from_json = local.custom_policy_assignments_from_json
  # mgmt_resoruce_prefix       = var.mgmt_resoruce_prefix
  custom_library_path = "./lib/custom_assignments"
}

output "debug" {
  value = {
    az_governance_config = module.az_governance
    archetype            = local.builtin_archetype_definitions_map_from_json
  }
}
