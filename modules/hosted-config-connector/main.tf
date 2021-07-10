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
    source          = "terraform-google-modules/project-factory/google//modules/project_services"
    project_id      = data.google_project.host_project.project_id

    activate_apis   = var.activate_apis
}

##################################################################
# 3. Config connector module
##################################################################
resource "null_resource" "hosted-config-connector"{
    provisioner "local-exec" {
        when            = create
        command         = "./scripts/install-hosted-config-connector.sh ${data.google_project.host_project.project_id} ${var.config_connecor_id} ${var.config_connector_region}"
    }
    provisioner "local-exec" {
        when            = destroy
        command         = "./scripts/uninstall-hosted-config-connector.sh ${data.google_project.host_project.project_id} ${var.config_connecor_id} ${var.config_connector_region}"
    }
}