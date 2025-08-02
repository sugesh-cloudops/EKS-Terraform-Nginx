# SpringBoot + PostgreSQL on EKS with Terraform, Helm, and Kustomize

## 📦 Project Overview

This repository provides an end-to-end setup for deploying a Spring Boot application connected to PostgreSQL, managed using:

- **Terraform**: Infrastructure as Code (EKS, VPC, IAM, etc.)
- **Helm**: Application templating and deployment
- **Kustomize**: Overlay management for environments (`dev`, `uat`)
- **Docker**: Containerization
- **GitHub Actions**: CI/CD pipelines for Terraform and Spring Boot
- **ArgoCD (optional)**: GitOps for K8s apps
- **Kind**: Local Kubernetes testing environment

---

## 🔧 Directory Structure

```bash
.
├── modules/                 # Terraform modules
│   ├── eks/                 # EKS cluster setup
│   ├── vpc/                 # VPC configuration
│   ├── aws-lbc/             # AWS Load Balancer Controller
│   ├── metric-server/       # K8s Metrics Server
│   ├── argocd/              # ArgoCD GitOps setup
│   ├── helm-provider/       # Helm provider config
│   ├── cluster-autoscaler/  # Cluster autoscaler module
│   ├── iam-user/            # IAM user setup
│   └── pod-identity-addon/  # Pod identity setup
├── main.tf / variables.tf / outputs.tf
├── backend/                 # Terraform remote backend config
├── helm-springboot-postgres/   # Helm chart for Spring Boot + PostgreSQL
│   └── templates/
├── Kustomize/               # Kustomize base and overlays
│   ├── base/
│   └── overlays/
│       ├── dev/
│       └── uat/
├── src/                     # Spring Boot source code
├── Dockerfile               # Spring Boot Dockerfile
├── docker-compose.yaml      # (Optional) Local testing
├── .github/workflows/       # GitHub Actions CI/CD
│   ├── terraform.yaml
│   ├── ci.yaml
│   └── springboot-postgres.yaml
├── pom.xml                  # Maven project file
└── README.md
