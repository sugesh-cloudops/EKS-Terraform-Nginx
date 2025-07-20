resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {
    name       = "argocd"
    repository = "https://argoproj.github.io/argo-helm"
    chart      = "argo-cd"
    version    = "5.43.0"
    
    namespace = "argocd"
    
    set {
        name  = "server.service.type"
        value = "ClusterIP"
    }
    
  
}
