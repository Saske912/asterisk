# resource "kubernetes_service" "goip" {
#   metadata {
#     name      = "goip"
#     namespace = kubernetes_namespace_v1.asterisk.metadata[0].name
#   }
#   spec {
#     type = "NodePort"
#     port {
#       port        = 5060
#       target_port = 5060
#       node_port   = 30060
#     }
#     external_ips = [""]
#   }
# }
