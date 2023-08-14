
module "config-controller"{
  source = "github.com/finiteloopme/tf-modules-argolis//modules/hosted-config-controller"
  host_project_id = module.manage-project-apis.project_id
  config_connector_region = local.network.us-central1.name
  config_connecor_id = local.conf_controller_name
  network_id = module.app-network.network_name
  subnet_id = local.network.us-central1.subnet

}

resource "google_project_iam_binding" "conf-ctrl-sa-owner-role-binding" {
  project          = module.manage-project-apis.project_id
  role    = "roles/logging.admin"
  members = [
    "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com",
  ]
}

# set the relevant permissions for logging, etc
# module "gke-workload-id-bindings" {
#     source   = "terraform-google-modules/iam/google//modules/projects_iam"
#     projects = [module.manage-project-apis.project_id]
#     bindings = {
#         "roles/owner" = [
#           "serviceAccount:${module.config-controller.config_controller_sa}",
#         ]
#         "roles/logging.admin" = [
#           "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com",
#         ]
#     }
# }
