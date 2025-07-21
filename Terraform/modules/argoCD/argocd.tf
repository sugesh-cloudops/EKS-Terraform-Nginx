resource "helm_release" "argocd" {
    name       = "argocd"
    repository = "https://argoproj.github.io/argo-helm"
    chart      = "argo-cd"
    version    = "5.43.0"
    
    namespace = "argocd"
    
    set {
        name  = "server.service.type"
        value = "LoadBalancer"
    }
    set {
        name  = "server.service.ports.https.port"
        value = "443"
    }

    set {
    name  = "server.service.ports.https.targetPort"
    value = "8080"
    }
  
}
