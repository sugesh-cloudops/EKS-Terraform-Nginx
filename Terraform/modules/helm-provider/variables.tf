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