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

resource "kubernetes_config_map_v1" "other" {
  metadata {
    name      = "other"
    namespace = kubernetes_namespace_v1.asterisk.metadata[0].name
  }
  data = {
    "MariaDB_odbc_data_source_template.ini" = <<EOT
[asterisk]
Driver=MariaDB ODBC 3.0 Driver
Description=покдючение к базе данных для asterisk
Server=${local.implicit_host}
Port=3306
Database=${var.asterisk.database}
EOT
    "config.ini"                            = <<EOT
# A generic, single database configuration.

[alembic]
# path to migration scripts
script_location = config

# template used to generate migration files
# file_template = %%(rev)s_%%(slug)s

# max length of characters to apply to the
# "slug" field
#truncate_slug_length = 40

# set to 'true' to run the environment during
# the 'revision' command, regardless of autogenerate
# revision_environment = false

#sqlalchemy.url = driver://user:pass@localhost/dbname

#sqlalchemy.url = postgresql://user:pass@localhost/asterisk
sqlalchemy.url = mysql://${var.asterisk.username}:${random_password.passowrd.result}@${local.implicit_host}/${var.asterisk.database}


# Logging configuration
[loggers]
keys = root,sqlalchemy,alembic

[handlers]
keys = console

[formatters]
keys = generic

[logger_root]
level = WARN
handlers = console
qualname =

[logger_sqlalchemy]
level = WARN
handlers =
qualname = sqlalchemy.engine

[logger_alembic]
level = INFO
handlers =
qualname = alembic

[handler_console]
class = StreamHandler
args = (sys.stderr,)
level = NOTSET
formatter = generic

[formatter_generic]
format = %(levelname)-5.5s [%(name)s] %(message)s
datefmt = %H:%M:%S

EOT
    "MariaDB_odbc_driver_template.ini"      = <<EOT
[MariaDB ODBC 3.0 Driver]
Description = MariaDB Connector/ODBC v.3.0
Driver = /usr/lib/libmaodbc.so
EOT
  }
}

resource "kubernetes_config_map_v1" "asterisk" {
  metadata {
    name      = "asterisk"
    namespace = kubernetes_namespace_v1.asterisk.metadata[0].name
  }
  data = {
    "modules.conf"  = <<EOT
[modules]
autoload = yes
preload => res_odbc.so
preload => res_config_odbc.so
preload-require = res_odbc.so
require = res_pjsip.so
EOT
    "logger.conf"   = <<EOT
[general]
dateformat = %F %T.%3q
use_callids = yes
appendhostname = yes
queue_log = yes
queue_log_to_file = no
queue_log_name = queue_log
queue_log_realtime_use_gmt = no
rotatestrategy = rotate
[logfiles]
console => notice,warning,error
security => security
full => notice,warning,error,verbose,dtmf,fax
EOT
    "asterisk.conf" = <<EOT
[options]
nofork=yes
verbose = 5
debug = 2
documentation_language = ru
EOT
    "pjsip.conf"    = <<EOT

[transport-tls]
type=transport
protocol=tls
bind=0.0.0.0:5061
cert_file=/etc/keys/tls.crt
priv_key_file=/etc/keys/tls.key


;--
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Non mapped elements start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

[goip-4]
username = ${var.asterisk.goip.username}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Non mapped elements end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
--;


[transport-udp]
type = transport
protocol = udp
bind = 0.0.0.0:5060

[goip-4]
type = aor
max_contacts = 1

[goip-4]
type = auth
username = ${var.asterisk.goip.username}
password = ${var.asterisk.goip.password}

[goip-4]
type = endpoint
context = from-trunk
dtmf_mode = rfc4733
disallow = all
allow = alaw
allow = ulaw
direct_media = no
auth = goip-4
outbound_auth = goip-4
aors = goip-4

[acl]
type = acl
permit = ${var.asterisk.goip.endpoint}/255.255.255.0
deny = 0.0.0.0/0.0.0.0

EOT
    # "pjsip_wizard.conf" = <<EOT
    # [goip]
    # type = wizard
    # # sends_auth = yes
    # # sends_registrations = yes
    # remote_hosts = ${var.asterisk.goip.endpoint}
    # outbound_auth/username = ${var.asterisk.goip.username}
    # outbound_auth/password = ${var.asterisk.goip.password}
    # endpoint/context = default
    # aor/qualify_frequency = 15
    # EOT
    "ccss.conf"        = <<EOT
[general]
cc_max_requests = 20
EOT
    "cel.conf"         = <<EOT
[general]
enable=yes
apps=dial,park
events=APP_START,CHAN_START,CHAN_END,ANSWER,HANGUP,BRIDGE_ENTER,BRIDGE_EXIT
EOT
    "cdr.conf"         = <<EOT
[general]
enable=yes
EOT
    "res_odbc.conf"    = <<EOT
[asterisk]
enabled => yes
dsn => asterisk
username => ${var.asterisk.username}
password => ${random_password.passowrd.result}
pre-connect => yes
EOT
    "sorcery.conf"     = <<EOT
[res_pjsip]
endpoint = realtime,ps_endpoints
auth = realtime,ps_auths
aor = realtime,ps_aors
domain_alias = realtime,ps_domain_aliases
contact=realtime,ps_contacts

[res_pjsip_endpoint_identifier_ip]
identify=realtime,ps_endpoint_id_ips
EOT
    "extconfig.conf"   = <<EOT
[settings]
ps_endpoints => odbc,asterisk
ps_auths => odbc,asterisk
ps_aors => odbc,asterisk
ps_domain_aliases => odbc,asterisk
ps_endpoint_id_ips =>  odbc,asterisk
ps_contacts => odbc,asterisk
EOT
    "http.conf"        = <<EOT
[general]
enabled=yes
bindaddr=0.0.0.0
bindport=8088
EOT
    "indications.conf" = <<EOT
[ru]
description = Russia
ringcadence = 1000,4000
dial = 425
busy = 425/250,0/250
ring = 425/1000,0/4000
congestion = 425/250,0/250,425/750,0/250
callwaiting = 425/50,0/1000
dialrecall = 350+440
record = 425/250,0/250
info = 950/330,1400/330,1800/330
stutter = 350+440
EOT
    "extensions.conf"  = <<EOT
[general]
[globals]
[sets]
exten => 100,1,Dial(PJSIP/0000f30A0A01)
exten => 101,1,Dial(PJSIP/0000f30B0B02)
exten => 102,1,Dial(PJSIP/SOFTPHONE_A)
exten => 103,1,Dial(PJSIP/SOFTPHONE_B)
exten => 200,1,Answer()
  same => n,Playback(hello-world)
  same => n,Hangup()
EOT
    "rtp.conf"         = <<EOT
[rtp_defaults]
general
rtpstart=10000
rtpend=10002
EOT
  }
}

data "vault_kv_secret_v2" "cluster" {
  mount = "kubernetes"
  name  = "cluster"
}

# resource "kubectl_manifest" "asterisk" {
#   yaml_body = <<EOT
# apiVersion: "cert-manager.io/v1"
# kind: "Certificate"
# metadata:
#   name: "asterisk"
#   namespace: ${kubernetes_namespace_v1.asterisk.metadata[0].name}
# spec:
#   secretName: "asterisk-tls"
#   issuerRef:
#     name: ${data.vault_kv_secret_v2.cluster.data["cluster_issuer"]}
#     kind: "ClusterIssuer"
#     group: "cert-manager.io"
#   dnsNames:
#   - asterisk.${var.base-domain}
# EOT
# }

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
        # host_network = true
        container {
          name    = "asterisk"
          image   = "saveloy/asterisk:0.7.1"
          command = ["/bin/sh", "-c"]
          args    = ["odbcinst -i -d -f /etc/MariaDB_odbc_driver_template.ini ; odbcinst -i -s -l -f /etc/MariaDB_odbc_data_source_template.ini;asterisk"]
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
