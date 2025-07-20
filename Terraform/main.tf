terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.13"
    }
  }

  backend "s3" {
    bucket         = "terraform-eks-state-s3-bucket-test"
    key            = "terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-eks-state-lock-table"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
}
provider "helm" {
  alias = "eks"
  

  kubernetes {
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
  
}

# EKS cluster outputs used for Helm setup
data "aws_eks_cluster" "eks" {
  name = module.eks.cluster_name
    # Ensure this waits for the EKS cluster to be created
  depends_on = [module.eks]
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_name

    # Ensure this waits for the EKS cluster to be created
  depends_on = [module.eks]
}

resource "null_resource" "wait_for_eks" {
  depends_on = [module.eks]

  provisioner "local-exec" {
    command = <<EOT
      aws eks wait cluster-active --region ${var.region} --name ${module.eks.cluster_name} && \
      for i in {1..30}; do kubectl get nodes --kubeconfig ~/.kube/config && break || sleep 10; done
    EOT
  }
}

resource "null_resource" "update_kubeconfig" {
  depends_on = [module.eks]

  provisioner "local-exec" {
    command = <<EOT
      aws eks update-kubeconfig --region ${var.region} --name ${module.eks.cluster_name}
    EOT
  }
}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  cluster_name         = var.cluster_name
}

module "eks" {
  source = "./modules/eks"

  cluster_name     = var.cluster_name
  cluster_version  = var.cluster_version
  vpc_id           = module.vpc.vpc_id
  subnet_ids       = module.vpc.private_subnet_ids
  node_groups      = var.node_groups
}

module "iam_user" {
  source = "./modules/iam-user"

  cluster_name = var.cluster_name
  eks_cluster  = module.eks.eks_cluster
}

# No longer needed as a separate module; Helm provider is now in root

module "metric_server" {
  source = "./modules/metric-server"

  metrics_server_namespace     = "kube-system"
  metrics_server_chart_version = "3.12.1"
  metrics_server_values_file   = "${path.root}/values/metrics-server.yaml"

  providers = {
    helm = helm.eks
  }

  depends_on = [module.eks, null_resource.update_kubeconfig]
}
module "pod_identity_addon" {
  source = "./modules/pod-identity-addon"

  cluster_name = var.cluster_name

  providers = {
    aws = aws
  }

  depends_on = [module.eks, null_resource.update_kubeconfig]
  
}
module "cluster_autoscaler" {
  source = "./modules/cluster-autoscaler"

  cluster_name = var.cluster_name
  region       = var.region

  providers = {
    helm = helm.eks
    aws  = aws
  }

  depends_on = [module.eks, null_resource.update_kubeconfig]
}

module "aws_lbc" {
  source = "./modules/aws-lbc"

  cluster_name = var.cluster_name
  region       = var.region

  providers = {
    helm = helm.eks
    aws  = aws
  }

  depends_on = [module.eks, null_resource.update_kubeconfig]
  
}
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}
module "argocd" {
  source = "./modules/argoCD"

  cluster_name = var.cluster_name
  region       = var.region

  providers = {
    helm = helm.eks
    aws  = aws
  }

  depends_on = [module.eks, null_resource.update_kubeconfig, kubernetes_namespace.argocd]
}