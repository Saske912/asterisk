# resource "helm_release" "asterisk" {
#   name       = "asterisk"
#   repository = "https://dysnix.github.io/charts"
#   chart      = "raw"
#   namespace  = kubernetes_namespace_v1.asterisk.metadata[0].name
#   version    = "v0.3.2"
#   values = [
#     yamlencode({
#       resources = [
#         {
#           apiVersion = "cert-manager.io/v1"
#           kind       = "Certificate"
#           metadata = {
#             name      = "asterisk"
#             namespace = kubernetes_namespace_v1.asterisk.metadata[0].name
#           }
#           spec = {
#             secretName = local.tls-secret
#             additionalOutputFormats = [{
#               type = "CombinedPEM"
#             }]
#             issuerRef = {
#               name  = var.issuer
#               kind  = "ClusterIssuer"
#               group = "cert-manager.io"
#             }
#             dnsNames = ["asterisk.${var.base-domain}"]
#           }
#         }
#       ]
#     })
#   ]
# }
