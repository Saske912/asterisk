terraform {
  backend "kubernetes" {
    secret_suffix = "asterisk"
    config_path   = "~/.kube/config"
  }
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "3.9.1"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    kubectl = {
      source = "gavinbunney/kubectl"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.13.1"
    }
  }
}

resource "kubernetes_namespace_v1" "asterisk" {
  metadata {
    name = "asterisk"
  }
}

data "vault_kv_secret_v2" "cluster" {
  mount = "kubernetes"
  name  = "cluster"
}

locals {
  tls-secret = "asterisk-tls"
}

resource "kubernetes_persistent_volume_claim_v1" "claims" {
  depends_on = [kubernetes_namespace_v1.asterisk]
  for_each   = local.claims
  metadata {
    name      = each.key
    namespace = kubernetes_namespace_v1.asterisk.metadata[0].name
    labels = {
      "storage" = "${each.key}-l"
    }
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = each.value.storage
      }
    }
  }
}

resource "kubernetes_config_map_v1" "env" {
  metadata {
    name      = "asterisk"
    namespace = kubernetes_namespace_v1.asterisk.metadata[0].name
  }
  data = local.vars
}

resource "kubernetes_deployment_v1" "asterisk" {
  depends_on = [helm_release.mariadb]
  metadata {
    name      = "asterisk"
    namespace = kubernetes_namespace_v1.asterisk.metadata[0].name
  }
  spec {
    template {
      metadata {
        labels = {
          app = "asterisk"
        }
      }
      spec {
        host_network = true
        container {
          security_context {
            privileged = true
            capabilities {
              add = ["NET_ADMIN"]
            }
          }
          name  = "asterisk-freepbx"
          image = "tiredofit/freepbx:5.2.0"
          dynamic "port" {
            for_each = local.ports
            content {
              name           = port.key
              container_port = port.value.number
              protocol       = port.value.protocol
            }
          }
          volume_mount {
            mount_path = "/certs"
            name       = "tls"
          }
          dynamic "volume_mount" {
            for_each = local.claims
            content {
              name       = volume_mount.key
              mount_path = volume_mount.value.path
            }
          }
          env_from {
            config_map_ref {
              name = kubernetes_config_map_v1.env.metadata[0].name
            }
          }
        }
        volume {
          name = "tls"
          secret {
            secret_name = local.tls-secret
          }
        }
        dynamic "volume" {
          for_each = local.claims
          content {
            name = volume.key
            persistent_volume_claim {
              claim_name = volume.key
            }
          }
        }
      }
    }
    selector {
      match_labels = {
        app = "asterisk"
      }
    }
  }
}

resource "kubernetes_service_v1" "asterisk" {
  metadata {
    name      = "asterisk"
    namespace = kubernetes_namespace_v1.asterisk.metadata[0].name
  }
  spec {
    type = "ClusterIP"
    selector = {
      app = "asterisk"
    }
    dynamic "port" {
      for_each = local.ports
      content {
        name        = port.key
        port        = port.value.number == 4433 ? 443 : port.value.number
        target_port = port.value.number
        protocol    = port.value.protocol
      }
    }
  }
}


resource "kubernetes_ingress_v1" "asterisk" {
  metadata {
    name      = "asterisk-ingress"
    namespace = kubernetes_namespace_v1.asterisk.metadata[0].name
    annotations = {
      # "nginx.ingress.kubernetes.io/ssl-redirect"       = "true"
      # "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
      # "nginx.ingress.kubernetes.io/backend-protocol"   = "HTTPS"
      # "nginx.ingress.kubernetes.io/use-regex"      = "true"
      # "nginx.ingress.kubernetes.io/rewrite-target" = "/$1"
      # "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }
  spec {
    ingress_class_name = "nginx"
    rule {
      host = "asterisk.${var.base-domain}"
      http {
        path {
          path      = "/admin/?(.*)"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service_v1.asterisk.metadata[0].name
              port {
                name = "http"
              }
            }
          }
        }
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service_v1.asterisk.metadata[0].name
              port {
                name = "http"
              }
            }
          }
        }
      }
    }
    tls {
      hosts = [
        "asterisk.${var.base-domain}"
      ]
      secret_name = "asterisk-tls"
    }
  }
}
