
module "config-controller"{
  source = "github.com/finiteloopme/tf-modules-argolis//modules/hosted-config-controller"
  # source ="../../../modules/hosted-config-controller"
  host_project_id = module.manage-project-apis.project_id
  config_connector_region = local.network.us-central1.name
  config_connecor_id = local.conf_controller_name
  network_id = module.app-network.network_name
  subnet_id = local.network.us-central1.subnet

  depends_on = [ time_sleep.wait_for_gcp_services ]
}

# module "conf-ctrl-sa-binding" {
#   source = "terraform-google-modules/iam/google//modules/service_accounts_iam"

#   service_accounts = [module.config-controller.config_controller_sa]
#   project          = module.manage-project-apis.project_id
#   # mode             = "additive"
#   bindings = {
#     "roles/owner" = [
#       "serviceAccount:${module.config-controller.config_controller_sa}",
#     ]
#   }
# }

resource "google_project_iam_binding" "conf-ctrl-sa-binding" {
  project          = module.manage-project-apis.project_id
  role    = "roles/owner"

  members = [
    "serviceAccount:${module.config-controller.config_controller_sa}"
  ]
}