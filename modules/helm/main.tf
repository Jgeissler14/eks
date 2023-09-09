module "nginx-ingress" {
    source = "./nginx-ingress"
    domain = var.domain
}