locals {
  service_name = var.ovh_project_id
}

resource "ovh_cloud_project_kube" "services" {
  service_name = local.service_name
  name         = var.ovh_project_name
  region       = var.ovh_region
}

resource "ovh_cloud_project_kube_nodepool" "services" {
  service_name  = local.service_name
  kube_id       = ovh_cloud_project_kube.services.id
  name          = "main"
  flavor_name   = var.ovh_flavor_name
  desired_nodes = 1
  max_nodes     = 2
  min_nodes     = 0
}