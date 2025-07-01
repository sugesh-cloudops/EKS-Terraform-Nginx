variable "metrics_server_namespace" {
  description = "Namespace where Metrics Server will be deployed"
  type        = string
  default     = "kube-system"
}

variable "metrics_server_chart_version" {
  description = "Version of the Metrics Server Helm chart"
  type        = string
  default     = "3.12.1"
}

variable "metrics_server_values_file" {
  description = "Path to the custom values file for Metrics Server"
  type        = string
}