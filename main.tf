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

resource "kubernetes_deployment_v1" "asterisk" {
  depends_on = [helm_release.mariadb]
  metadata {
    name      = "asterisk"
    namespace = kubernetes_namespace_v1.asterisk.metadata[0].name
  }
  spec {
    strategy {
      type = "Recreate"
    }
    template {
      metadata {
        labels = {
          app = "asterisk"
        }
      }
      spec {
        host_network = true
        container {
          name        = "asterisk"
          image       = "saveloy/asterisk:0.7.1"
          working_dir = "/var/lib/asterisk/sounds"
          command     = ["/bin/sh", "-c"]
          args        = ["odbcinst -i -d -f /etc/MariaDB_odbc_driver_template.ini ; odbcinst -i -s -l -f /etc/MariaDB_odbc_data_source_template.ini;asterisk"]
          dynamic "port" {
            for_each = local.ports
            content {
              name           = port.key
              container_port = port.value.number
              protocol       = port.value.protocol
            }
          }
          volume_mount {
            mount_path = "/etc/asterisk"
            name       = "asterisk"
          }
          volume_mount {
            mount_path = "/etc/keys"
            name       = "tls"
          }
          volume_mount {
            mount_path = "/usr/local/src/asterisk-20.1.0/contrib/ast-db-manage/config.ini"
            name       = "config"
            sub_path   = "config.ini"
          }
          volume_mount {
            mount_path = "/etc/MariaDB_odbc_data_source_template.ini"
            name       = "odbc"
            sub_path   = "MariaDB_odbc_data_source_template.ini"
          }
          volume_mount {
            mount_path = "/etc/MariaDB_odbc_driver_template.ini"
            name       = "odbc-driver"
            sub_path   = "MariaDB_odbc_driver_template.ini"
          }
        }
        volume {
          name = "odbc-driver"
          config_map {
            name = kubernetes_config_map_v1.other.metadata[0].name
            items {
              key  = "MariaDB_odbc_driver_template.ini"
              path = "MariaDB_odbc_driver_template.ini"
            }
          }
        }
        volume {
          name = "config"
          config_map {
            name = kubernetes_config_map_v1.other.metadata[0].name
            items {
              key  = "config.ini"
              path = "config.ini"
            }
          }
        }
        volume {
          name = "odbc"
          config_map {
            name = kubernetes_config_map_v1.other.metadata[0].name
            items {
              key  = "MariaDB_odbc_data_source_template.ini"
              path = "MariaDB_odbc_data_source_template.ini"
            }
          }
        }
        volume {
          name = "tls"
          secret {
            secret_name = "asterisk-tls"
          }
        }
        volume {
          name = "asterisk"
          config_map {
            name = kubernetes_config_map_v1.asterisk.metadata[0].name
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
    # type = "LoadBalancer"
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
  }
  spec {
    ingress_class_name = "nginx"
    rule {
      host = "asterisk.${var.base-domain}"
      http {
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
