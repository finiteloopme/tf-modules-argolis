# Disable requires shielded VM org policy 
module "disable-requiresShieldedVm" {
  source            = "terraform-google-modules/org-policy/google"
  policy_for        = "project"
  project_id        = data.google_project.project.project_id
  constraint        = "constraints/compute.requireShieldedVm"
  policy_type       = "boolean"
  enforce           = false
}

# Allow list, creation of an external IP address
module "enable-vmExternalIpAccess" {
  source            = "terraform-google-modules/org-policy/google"
  policy_for        = "project"
  project_id        = data.google_project.project.project_id
  constraint        = "constraints/compute.vmExternalIpAccess"
  policy_type       = "list"
  enforce           = false
}

# Manage Project APIs
module "manage-project-apis" {
    source = "terraform-google-modules/project-factory/google//modules/project_services"
    project_id = data.google_project.project.project_id

    activate_apis = local.project_apis

    # Don't disable services (APIs) when the resources are destroyed
    disable_services_on_destroy = false
}

# We need to wait for services to "start"
resource "time_sleep" "wait_for_gcp_services" {
  create_duration = "10s"

  depends_on = [module.manage-project-apis]
}

