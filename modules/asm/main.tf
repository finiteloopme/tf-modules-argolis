
data "google_container_cluster" "asm_cluster"{
  name                  = var.gke_cluster
  location              = var.gke_location
  project               = var.project_id
}

module "asm" {
  source                = "terraform-google-modules/kubernetes-engine/google//modules/asm"

  project_id            = var.project_id
  cluster_name          = var.gke_cluster
  location              = var.gke_location
  cluster_endpoint      = data.google_container_cluster.asm_cluster.endpoint
  enable_all            = true

  # options               = ["vm,hub-meshca,envoy-access-log,egressgateways,cloud-tracing,multicluster"]
  options               = ["vm"]
  # custom_overlays       = ["./custom_ingress_gateway.yaml"]
  skip_validation       = true
  outdir                = "./${var.gke_cluster}-outdir"
}
