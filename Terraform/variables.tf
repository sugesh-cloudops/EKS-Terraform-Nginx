variable "region" {
  description = "AWS region"
  type        = string
  default = "us-west-2"
  
}
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default = "10.0.0.0/16"
  
}
variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default = ["us-west-2a", "us-west-2b", "us-west-2c"]
  
}
variable "private_subnet_cidrs" {
  description = "CIDR blocks for the private subnets"
  type        = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}
variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "Test-cluster"
}
variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.30"
}
variable "node_groups" {
  description = "EKS node group configuration"
  type = map(object({
    instance_types = list(string)
    capacity_type  = string
    scaling_config = object({
      desired_size = number
      max_size     = number
      min_size     = number
    })
  }))
  default = {
    general ={
      instance_types = ["t2.medium"]
      capacity_type  = "ON_DEMAND"
      scaling_config = {
        desired_size = 1
        max_size     = 2
        min_size     = 1
      }
    }
  }
}   

