# resource "helm_release" "nginx_ingress" {
#   name       = "ingress-nginx"
#   repository = "https://kubernetes.github.io/ingress-nginx"
#   chart      = "ingress-nginx"
#   version    = "4.8.3"
#   namespace  = var.namespace
#   create_namespace = true


#   set {
#     name  = "controller.nodeSelector.kubernetes\\.io/os"
#     value = "linux"
#   }

#   set {
#     name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-health-probe-request-path"
#     value = "/healthz"
#   }

#   set {
#     name  = "metrics.enabled"
#     value = "true"
#   }

#   set {
#     name  = "controller.podAnnotations.prometheus\\.io/scrape"
#     value = "true"
#   }

#   depends_on = [azurerm_kubernetes_cluster.this]
# }

# resource "helm_release" "prometheus_grafana" {
#   name       = "kube-prometheus-stack"
#   repository = "https://prometheus-community.github.io/helm-charts"
#   chart      = "kube-prometheus-stack"
#   namespace  = "monitoring"
#   create_namespace = true

#   values = [
#     file("values/prometheus.yaml")
#   ]

#   depends_on = [azurerm_kubernetes_cluster.this]

# }

# resource "helm_release" "cert_manager" {
#   name       = "cert-manager"
#   repository = "https://charts.jetstack.io"
#   chart      = "cert-manager"
#   version    = "1.16.2"
#   namespace  = var.namespace
#   create_namespace = true

#   set {
#     name  = "crds.enabled"
#     value = "true"
#   }

#   depends_on = [azurerm_kubernetes_cluster.this]
# }

# resource "helm_release" "argocd" {
#   name       = "argocd"
#   repository = "https://argoproj.github.io/argo-helm"
#   chart      = "argo-cd"
#   version    = "3.35.4"
#   namespace  = "argocd"
#   create_namespace = true

#   values = [ file("values/argocd.yaml") ]

#   depends_on = [azurerm_kubernetes_cluster.this]
# }



# # resource "helm_release" "greetify" {
# #   name      = "greetify"
# #   chart     = "../../helm/greetify"
# #   create_namespace = true
# #   namespace = var.namespace

# #   #values = ["../../helm/greetify/values.yaml"]

# #   depends_on = [helm_release.cert_manager, azurerm_kubernetes_cluster.this]
# # }



