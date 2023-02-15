provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "docker" {
  registry_auth {
    address = "registry-1.docker.io"
    config_file = pathexpand("~/.docker/config.json")
  }
}

data "vault_generic_secret" "mariadb" {
  path = "kv/databases/mariadb"
}

data kubernetes_namespace_v1 asterisk {
  metadata {
    name = "asterisk"
  }
}

resource "docker_registry_image" "asterisk" {
  name = "saveloy/asterisk"
  build {
    context = path.cwd
    auth_config {
      host_name = "saveloy/asterisk"
    }
  }
}

resource "kubernetes_config_map_v1" "asterisk" {
  metadata {
    name = "asterisk"
    namespace = data.kubernetes_namespace_v1.asterisk.metadata[0].name
  }
  data = {
    "odbc.ini" =<<EOT
[asterisk]
Driver = MySQL
Description = покдючение к базе данных для asterisk
Sever = mariadb.mariadb
Post = 3306
Database = asterisk
UserName = root
Password = ${data.vault_generic_secret.mariadb.data["password"]}
EOT
    "modules.conf" =<<EOT
[modules]
autoload = no
; Applications

load = app_bridgewait.so
load = app_dial.so
load = app_playback.so
load = app_stack.so
load = app_verbose.so
load = app_voicemail.so
load = app_directory.so
load = app_confbridge.so
load = app_queue.so

; Bridging

load = bridge_builtin_features.so
load = bridge_builtin_interval_features.so
load = bridge_holding.so
load = bridge_native_rtp.so
load = bridge_simple.so
load = bridge_softmix.so

; Call Detail Records

load = cdr_custom.so

; Channel Drivers

load = chan_bridge_media.so
load = chan_pjsip.so

; Codecs

load = codec_gsm.so
load = codec_resample.so
load = codec_ulaw.so
load = codec_g722.so

; Formats

load = format_gsm.so
load = format_pcm.so
load = format_wav_gsm.so
load = format_wav.so

; Functions

load = func_callerid.so
load = func_cdr.so
load = func_pjsip_endpoint.so
load = func_sorcery.so
load = func_devstate.so
load = func_strings.so

; Core/PBX

load = pbx_config.so

; Resources

load = res_http_websocket.so
load = res_musiconhold.so
load = res_pjproject.so
load = res_pjsip_acl.so
load = res_pjsip_authenticator_digest.so
load = res_pjsip_caller_id.so
load = res_pjsip_dialog_info_body_generator.so
load = res_pjsip_diversion.so
load = res_pjsip_dtmf_info.so
load = res_pjsip_endpoint_identifier_anonymous.so
load = res_pjsip_endpoint_identifier_ip.so
load = res_pjsip_endpoint_identifier_user.so
load = res_pjsip_exten_state.so
load = res_pjsip_header_funcs.so
load = res_pjsip_logger.so
load = res_pjsip_messaging.so
load = res_pjsip_mwi_body_generator.so
load = res_pjsip_mwi.so
load = res_pjsip_nat.so
load = res_pjsip_notify.so
load = res_pjsip_one_touch_record_info.so
load = res_pjsip_outbound_authenticator_digest.so
load = res_pjsip_outbound_publish.so
load = res_pjsip_outbound_registration.so
load = res_pjsip_path.so
load = res_pjsip_pidf_body_generator.so
load = res_pjsip_pidf_digium_body_supplement.so
load = res_pjsip_pidf_eyebeam_body_supplement.so
load = res_pjsip_publish_asterisk.so
load = res_pjsip_pubsub.so
load = res_pjsip_refer.so
load = res_pjsip_registrar.so
load = res_pjsip_rfc3326.so
load = res_pjsip_sdp_rtp.so
load = res_pjsip_send_to_voicemail.so
load = res_pjsip_session.so
load = res_pjsip.so
load = res_pjsip_t38.so
load = res_pjsip_transport_websocket.so
load = res_pjsip_xpidf_body_generator.so
load = res_rtp_asterisk.so
load = res_sorcery_astdb.so
load = res_sorcery_config.so
load = res_sorcery_memory.so
load = res_sorcery_realtime.so
load = res_timing_timerfd.so

noload = res_hep.so
noload = res_hep_pjsip.so
noload = res_hep_rtcp.so

preload=res_odbc.so
preload=res_config.so
EOT
    "logger.conf" =<<EOT
[general]

[logfiles]

console = verbose,notice,warning,error

;messages = notice,warning,error
;full = verbose,notice,warning,error,debug
;security = security
EOT
    "asterisk.conf" =<<EOT
[options]
nofork=yes
; If we want to start Asterisk with a default verbosity for the verbose
; or debug logger channel types, then we use these settings (by default
; they are disabled).
;verbose = 5
;debug = 2

; User and group to run asterisk as. NOTE: This will require changes to
; directory and device permissions.
;runuser = asterisk		; The user to run as. The default is root.
;rungroup = asterisk		; The group to run as. The default is root

;defaultlanguage = es
EOT
    "config.ini" =<<EOT
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
sqlalchemy.url = mysql://root:${data.vault_generic_secret.mariadb.data["password"]}@mariadb.mariadb/asterisk


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
  }
}

resource kubernetes_deployment_v1 "asterisk" {
  depends_on = [docker_registry_image.asterisk]
  metadata {
    name = "asterisk"
    namespace = data.kubernetes_namespace_v1.asterisk.metadata[0].name
  }
  spec {
    template {
      metadata {
        labels = {
          app = "asterisk"
        }
      }
      spec {
        container {
          name = "asterisk"
          image = "saveloy/asterisk"
          command = ["/bin/sh"]
          args = ["-c", "alembic -c config.ini && asterisk"]
          port {
            name = "pjsip"
            container_port = 5060
          }
          port {
            name = "pjsip-secure"
            container_port = 5061
          }
          volume_mount {
            mount_path = "/etc/odbc.ini"
            name       = "odbc"
            sub_path = "odbc.ini"
          }
          volume_mount {
            mount_path = "/etc/asterisk/logger.conf"
            name       = "logger"
            sub_path = "logger.conf"
          }
          volume_mount {
            mount_path = "/etc/asterisk/modules.conf"
            name       = "modules"
            sub_path = "modules.conf"
          }
          volume_mount {
            mount_path = "/etc/asterisk/asterisk.conf"
            name       = "asterisk"
            sub_path = "asterisk.conf"
          }
          volume_mount {
            mount_path = "/usr/local/src/asterisk-20.1.0/contrib/ast-db-manage/config.ini"
            name       = "config"
            sub_path = "config.ini"
          }
        }
        volume {
          name = "config"
          config_map {
            name = kubernetes_config_map_v1.asterisk.metadata[0].name
            items {
              key = "config.ini"
            }
          }
        }
        volume {
          name = "odbc"
          config_map {
            name = kubernetes_config_map_v1.asterisk.metadata[0].name
            items {
              key = "odbc.ini"
            }
          }
        }
        volume {
          name = "logger"
          config_map {
            name = kubernetes_config_map_v1.asterisk.metadata[0].name
            items {
              key = "logger.conf"
            }
          }
        }
        volume {
          name = "modules"
          config_map {
            name = kubernetes_config_map_v1.asterisk.metadata[0].name
            items {
              key = "modules.conf"
            }
          }
        }
        volume {
          name = "asterisk"
          config_map {
            name = kubernetes_config_map_v1.asterisk.metadata[0].name
            items {
              key = "asterisk.conf"
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
    name = "asterisk"
    namespace = data.kubernetes_namespace_v1.asterisk.metadata[0].name
  }
  spec {
    selector = {
      app = "asterisk"
    }
    port {
      port = 5060
      target_port = "pjsip"
    }
    port {
      port = 5061
      target_port = "pjsip-secure"
    }
  }
}