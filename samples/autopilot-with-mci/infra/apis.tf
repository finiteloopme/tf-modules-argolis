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
    source = "github.com/finiteloopme/tf-modules-argolis//modules/manage-gcp-apis"
    project_id = data.google_project.project.project_id
    project_apis = local.project_apis
}

# Logging permission for default compute SA
resource "google_project_iam_binding" "default-sa-logging-role-binding" {
  project          = module.manage-project-apis.project_id
  role    = "roles/logging.admin"
  members = [
    "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com",
  ]
}