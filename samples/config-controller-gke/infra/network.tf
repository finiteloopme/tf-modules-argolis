module "app-network" {
    source = "github.com/finiteloopme/tf-modules-argolis//modules/network-custom"
    project_id = module.manage-project-apis.project_id
    network_name = local.network_name
    subnets = local.subnets
}