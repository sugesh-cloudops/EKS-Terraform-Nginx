output "metrics_server_release_name" {
  description = "The name of the Metrics Server Helm release"
  value       = helm_release.metrics-server.name
}

output "metrics_server_namespace" {
  description = "The namespace where Metrics Server was installed"
  value       = helm_release.metrics-server.namespace
}

output "metrics_server_status" {
  description = "Status of the Helm release"
  value       = helm_release.metrics-server.status
}