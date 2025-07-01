output "eks_cluster_endpoint" {
  description = "EKS cluster API server endpoint"
  value       = data.aws_eks_cluster.eks.endpoint
}

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = data.aws_eks_cluster.eks.name
}