variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

provider "aws" {
  region = var.region
}

variable "eks_cluster_endpoint" {
  description = "EKS cluster API server endpoint"
  type        = string
}

variable "eks_cluster_ca_certificate" {
  description = "EKS cluster CA certificate"
  type        = string
}

variable "eks_cluster_token" {
  description = "EKS cluster authentication token"
  type        = string
}