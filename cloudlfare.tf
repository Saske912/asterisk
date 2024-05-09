resource "cloudflare_record" "asterisk-tls" {
  zone_id = var.cloudflare.zone.default
  name    = "asterisk"
  type    = "SRV"
  data {
    service  = "_sip"
    name     = "asterisk."
    proto    = "_tls"
    priority = 0
    weight   = 5
    port     = 5061
    target   = "asterisk.my-flora.shop."
  }
}
# resource "cloudflare_record" "asterisk-udp" {
#   zone_id = var.cloudflare.zone.default
#   name    = "sip"
#   type    = "SRV"
#   data {
#     service  = "_sip"
#     name     = "sip."
#     proto    = "_udp"
#     priority = 0
#     weight   = 5
#     port     = 5060
#     target   = "sip.my-flora.shop."
#   }
# }
