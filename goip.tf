resource "kubernetes_service" "goip" {
  metadata {
    name      = "goip"
    namespace = kubernetes_namespace_v1.asterisk.metadata[0].name
  }

  spec {
    port {
      port        = 80
      target_port = 80
      name        = "http"
    }
    port {
      port        = 9991
      target_port = "sms"
      name        = "sms"
      protocol    = "TCP"
    }
    port {
      port        = 9991
      target_port = "sms-udp"
      name        = "sms-udp"
      protocol    = "UDP"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_endpoints" "goip" {
  metadata {
    name      = kubernetes_service.goip.metadata[0].name
    namespace = kubernetes_service.goip.metadata[0].namespace
  }

  subset {
    address {
      ip = "10.0.0.10"
    }

    port {
      port = 80
      name = "http"
    }
    port {
      port = 9991
      name = "sms"
    }
    port {
      port     = 9991
      name     = "sms-udp"
      protocol = "UDP"
    }
  }
}
