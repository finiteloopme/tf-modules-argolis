# Get the project
data "google_project" "project" {
    project_id = var.project_id
}

# Manage Project APIs
module "manage-project-apis" {
    source = "terraform-google-modules/project-factory/google//modules/project_services"
    project_id = data.google_project.project.project_id

    activate_apis = var.project_apis

    # Don't disable services (APIs) when the resources are destroyed
    disable_services_on_destroy = false
}

# We need to wait for services to "start"
resource "time_sleep" "wait_for_gcp_services" {
  create_duration = var.wait_time

  depends_on = [module.manage-project-apis]
}

