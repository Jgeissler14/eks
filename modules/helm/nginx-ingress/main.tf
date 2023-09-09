resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  repository = "https://helm.nginx.com/stable"
  chart      = "nginx-ingress"
  namespace  = "nginx-ingress"
  create_namespace = true

  values = [
    # Customize Helm values for the Nginx Ingress Controller here, if needed
  ]
}
