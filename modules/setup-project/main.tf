
/******************************************
  1. Grant Org Policy Admin role to the TF Runner
 *****************************************/

 module "org-policy-admin-binding" {
    source          = "terraform-google-modules/iam/google//modules/organizations_iam"
    organizations   = [var.organisation_id]
    mode            = "additive"
    bindings        = {
        "roles/orgpolicy.policyAdmin" = [
            "user:${var.project_admin_tf_runner}",
        ]
    }
}


/******************************************
  2. Enable required APIs for the project
 *****************************************/
# Get Project
data "google_project" "project_to_activate" {
    project_id          = var.project_id
}

# Activate APIs
module "project-services" {
    source          = "terraform-google-modules/project-factory/google//modules/project_services"
    project_id      = data.google_project.project_to_activate.project_id

    activate_apis   = var.activate_apis
}

# Set the required Org Policies for the project
# Boolean policies
module "org-policies-boolean" {
  source            = "terraform-google-modules/org-policy/google"
  policy_for        = "project"
  for_each          = var.boolean_org_policies
  project_id        = data.google_project.project_to_activate.project_id
  constraint        = each.key
  policy_type       = "boolean"
  enforce           = each.value
  depends_on        = [
    module.org-policy-admin-binding
  ]
}
# Allow list = ALL
module "org-policies-allow-list" {
  source            = "terraform-google-modules/org-policy/google"
  policy_for        = "project"
  for_each          = toset(var.allow_org_policies)
  project_id        = data.google_project.project_to_activate.project_id
  constraint        = each.key
  policy_type       = "list"
  enforce           = false
  depends_on        = [
    module.org-policy-admin-binding
  ]
}
# Deny list = ALL
module "org-policies-deny-list" {
  source            = "terraform-google-modules/org-policy/google"
  policy_for        = "project"
  for_each          = toset(var.deny_org_policies)
  project_id        = data.google_project.project_to_activate.project_id
  constraint        = each.key
  policy_type       = "list"
  enforce           = true
  depends_on        = [
    module.org-policy-admin-binding
  ]
}

/******************************************
  3. Create `default` network
 *****************************************/
# Create Network
module "create-default-network-and-firewall-rules" {
  # source            = "git::https://github.com/finiteloopme/tf-modules-argolis.git//modules/gce"
    source  = "../network"

    project_id      = data.google_project.project_to_activate.project_id
}

/******************************************
  4. Get the default service account
 *****************************************/
data "google_compute_default_service_account" "default_sa" {
    project         = data.google_project.project_to_activate.project_id
}
