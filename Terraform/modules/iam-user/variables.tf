variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}
variable "eks_cluster" {
  description = "The EKS cluster resource"
  type        = any
}