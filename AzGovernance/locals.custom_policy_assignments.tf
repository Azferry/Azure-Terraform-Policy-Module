


locals {
  custom_library_path = "./lib/custom_assignments"

  custom_policy_assignments_from_json = tolist(fileset(local.custom_library_path, "**/policy_assignment_*.{json,json.tftpl}"))

}