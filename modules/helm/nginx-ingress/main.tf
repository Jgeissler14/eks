resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  chart      = "nginx-stable/nginx-ingress"
  namespace  = "nginx-ingress"
  create_namespace = true

  values = [
    # Customize Helm values for the Nginx Ingress Controller here, if needed
  ]
}
