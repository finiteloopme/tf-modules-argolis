module "default-network" {
    source  = "github.com/finiteloopme/tf-modules-argolis//modules/network"
    project_id = module.manage-project-apis.project_id
}