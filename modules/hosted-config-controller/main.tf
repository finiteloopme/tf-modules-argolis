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
resource "null_resource" "config-contoller"{

  triggers = {
    project_id          = data.google_project.host_project.project_id
    config_connecor_id  = var.config_connecor_id
    config_connector_region = var.config_connector_region
  }

    provisioner "local-exec" {
        when            = create
        command         = "${path.module}/scripts/install-hosted-config-connector.sh  ${self.triggers.project_id} ${self.triggers.config_connecor_id} ${self.triggers.config_connector_region}"
    }

    provisioner "local-exec" {
        when            = destroy
        command         = "${path.module}/scripts/uninstall-hosted-config-connector.sh ${self.triggers.project_id} ${self.triggers.config_connecor_id} ${self.triggers.config_connector_region}"
    }

    depends_on = [
        module.project-services,
    ]
}
