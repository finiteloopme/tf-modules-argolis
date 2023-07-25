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

# We need to wait for services to "start"
resource "time_sleep" "wait_for_gcp_services" {
  create_duration = "10s"

  depends_on = [module.project-services]
}

##################################################################
# 3. Config connector module
##################################################################
locals {
    sa-output-file = "${path.module}/sa-output.txt"
}

resource "null_resource" "config-controller"{

  triggers = {
    project_id          = data.google_project.host_project.project_id
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

    depends_on = [
        time_sleep.wait_for_gcp_services,
    ]
}

data "local_file" "config-controller-sa"{
    filename    = local.sa-output-file
    depends_on  = [
        resource.null_resource.config-controller
    ]
}