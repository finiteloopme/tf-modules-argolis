##################################################################
# 1. Get the project where config connector will be hosted
##################################################################
data "google_project" "host_project" {
    project_id          = var.host_project_id
}

##################################################################
# 2. Activate Services
##################################################################
module "project-services" {
    source = "github.com/finiteloopme/tf-modules-argolis//modules/manage-gcp-apis"
    project_id      = data.google_project.host_project.project_id

    project_apis   = var.activate_apis
    
}
##################################################################
# 3. Config connector module
##################################################################
locals {
    sa-output-file = "${path.module}/sa-output.txt"
}

resource "null_resource" "config-controller"{

  triggers = {
    project_id          = module.project-services.project_id
    config_connecor_id  = var.config_connecor_id
    config_connector_region = var.config_connector_region
    network = var.network_id
    subnet = var.subnet_id
  }

    provisioner "local-exec" {
        when            = create
        command         = "${path.module}/scripts/install-hosted-config-connector.sh  ${self.triggers.project_id} ${self.triggers.config_connecor_id} ${self.triggers.config_connector_region} ${local.sa-output-file} ${self.triggers.network} ${self.triggers.subnet}"
    }

    provisioner "local-exec" {
        when            = destroy
        command         = "${path.module}/scripts/uninstall-hosted-config-connector.sh ${self.triggers.project_id} ${self.triggers.config_connecor_id} ${self.triggers.config_connector_region}"
    }

}

data "local_file" "config-controller-sa"{
    filename    = local.sa-output-file
    depends_on  = [
        resource.null_resource.config-controller
    ]
}

resource "google_project_iam_binding" "conf-ctrl-sa-owner-role-binding" {
  project          = data.google_project.host_project.project_id
  role    = "roles/owner"
  members = [
    "serviceAccount:${data.local_file.config-controller-sa.content}"
  ]
   depends_on = [ null_resource.config-controller ]
}