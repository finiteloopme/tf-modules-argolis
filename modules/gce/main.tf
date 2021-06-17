module "startup-script" {
  source = "git::https://github.com/terraform-google-modules/terraform-google-startup-scripts.git?ref=v0.1.0"
  enable_setup_sudoers = true
}

# TODO - Replace this with 
# https://github.com/finiteloopme/tf-modules-argolis/modules/gce_template
module "instance_template" {
  source          = "terraform-google-modules/vm/google//modules/instance_template"

  region          = var.gcp_region
  project_id      = data.google_project.gcp_project.project_id
  subnetwork        = data.google_compute_subnetwork.vm_subnetwork.self_link
  # TODO: check if the service account is supplied
  # service_account = var.service_account
  service_account = {
    email  = data.google_compute_default_service_account.default_sa.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
  machine_type    = var.machine_type

  source_image_family = var.source_image_family
  source_image_project = var.source_image_project
  tags                = var.instance_tags

  metadata          = {
    startup-script        = module.startup-script.content
    startup-script-custom = var.startup_script
  }
}

module "compute_instance" {
  source            = "terraform-google-modules/vm/google//modules/compute_instance"

  region            = var.gcp_region
  # zone              = var.gcp_zone
  subnetwork        = data.google_compute_subnetwork.vm_subnetwork.self_link
  num_instances     = 1
  hostname          = var.instance_name
  instance_template = module.instance_template.self_link
  access_config = [{
    nat_ip       = var.nat_ip
    network_tier = var.network_tier
  }, ]
}