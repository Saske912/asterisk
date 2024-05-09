
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
Server=${local.host}
Port=3306
Database=${var.asterisk.database}
EOT
    "config.ini"                            = <<EOT
# A generic, single database configuration.

[alembic]
# path to migration scripts
script_location = config
sqlalchemy.url = mysql://${var.asterisk.username}:${random_password.passowrd.result}@${local.host}/${var.asterisk.database}


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
    "modules.conf"         = <<EOT
[modules]
autoload = yes
preload => res_odbc.so
preload => res_config_odbc.so
preload-require = res_odbc.so
require = res_pjsip.so
load => res_config_mysql.so
load => app_realtime.so
load => func_realtime.so
load => pbx_realtime.so
load = res_security_log.so
EOT
    "logger.conf"          = <<EOT
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
console => notice,warning,error,verbose,dtmf
security => security
full => notice,warning,error,verbose,dtmf,fax
EOT
    "asterisk.conf"        = <<EOT
[options]
nofork=yes
verbose = 5
debug = 2
languageprefix = yes
documentation_language = ru
dumpcore = yes
EOT
    "pjsip.conf"           = <<EOT
[global]
type=global
;transport=udp,tcp

[transport-tls]
type=transport
protocol=tls
bind=0.0.0.0:5061
cert_file=/etc/keys/tls.crt
priv_key_file=/etc/keys/tls.key

[transport-udp]
type = transport
protocol = udp
bind = 0.0.0.0:5060

EOT
    "pjsip_wizard.conf"    = <<EOT
     [goip_16_2]
     type = wizard
     sends_auth = yes
     sends_registrations = yes
     accepts_auth = yes
     accepts_registrations = no
     endpoint/context=default
     endpoint/transport=transport-udp
     endpoint/allow = !all,ulaw,alaw
     remote_hosts = ${var.asterisk.goip.endpoint}
     outbound_auth/username = ${var.asterisk.goip.username}
     outbound_auth/password = ${var.asterisk.goip.password}
    EOT
    "ccss.conf"            = <<EOT
[general]
cc_max_requests = 20
EOT
    "cel.conf"             = <<EOT
[general]
enable=yes
apps=dial,park
events=APP_START,CHAN_START,CHAN_END,ANSWER,HANGUP,BRIDGE_ENTER,BRIDGE_EXIT
EOT
    "cdr.conf"             = <<EOT
[general]
enable=yes
EOT
    "res_odbc.conf"        = <<EOT
[asterisk]
enabled => yes
dsn => asterisk
username => ${var.asterisk.username}
password => ${random_password.passowrd.result}
pre-connect => yes
EOT
    "sorcery.conf"         = <<EOT
[res_pjsip]
endpoint = realtime,ps_endpoints
auth = realtime,ps_auths
aor = realtime,ps_aors
domain_alias = realtime,ps_domain_aliases
contact=realtime,ps_contacts
queue = realtime,queues
queue_member = realtime,queue_members

[res_pjsip_endpoint_identifier_ip]
identify=realtime,ps_endpoint_id_ips
[res_pjsip_outbound_registration]
registration=realtime,ps_registrations
EOT
    "res_config_odbc.conf" = <<EOT
[asterisk]
enabled => yes
dsn => config
username => ${var.asterisk.username}

EOT
    "extconfig.conf"       = <<EOT
[settings]
ps_endpoints => odbc,asterisk
ps_auths => odbc,asterisk
ps_aors => odbc,asterisk
ps_domain_aliases => odbc,asterisk
ps_endpoint_id_ips =>  odbc,asterisk
ps_contacts => odbc,asterisk
ps_registrations => odbc,asterisk
extensions => odbc,asterisk,extensions
queues => odbc,asterisk;,voice_queue
queue_members => odbc,asterisk;,voice_agenci

sipusers => odbc,asterisk,sippeers
sippeers => odbc,asterisk,sippeers
EOT
    "http.conf"            = <<EOT
[general]
enabled=yes
bindaddr=0.0.0.0
bindport=8088
EOT
    "indications.conf"     = <<EOT
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
    "extensions.conf"      = <<EOT
    [general]
    [globals]
    [default]
    switch => Realtime/@
    exten => 103,1,Dial(PJSIP/103)
    exten => 104,1,Dial(PJSIP/104)
    exten => 200,1,Answer()
      same => n,Playback(ru/vm-sorry)
      same => n,Hangup()
;    exten => _+7XXXXXXXXXX,1,Dial(PJSIP/goip_16_2/$${EXTEN})
;    exten => _+7XXXXXXXXXX,1,Dial(PJSIP/goip/$${EXTEN})
;    exten => _8XXXXXXXXXX,1,Dial(PJSIP/goip_16_2/$${EXTEN})
;    exten => _XXXXXXXXXXX,1,Dial(PJSIP/goip_16_2/$${EXTEN})
;    exten => _1.,1,Dial(PJSIP/goip_16_2/$${EXTEN})
    EOT
    "rtp.conf"             = <<EOT
[rtp_defaults]
[general]
[default]
rtpstart=10000
rtpend=10032
EOT
  }
}
