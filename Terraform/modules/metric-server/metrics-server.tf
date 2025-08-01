terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
    }
  }
}

resource "helm_release" "metrics-server" {
  provider   = helm
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server"
  chart      = "metrics-server"
  namespace  = var.metrics_server_namespace
  version    = var.metrics_server_chart_version

  values = [
    file(var.metrics_server_values_file)
  ]

}