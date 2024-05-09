locals {
  #   vars = tomap({
  #     DB_HOST                    = "10.0.0.45"
  #     DB_NAME                    = var.asterisk.database
  #     DB_USER                    = var.asterisk.username
  #     DB_PASS                    = random_password.passowrd.result
  #     ENABLE_FOP                 = "TRUE"
  #     ENABLE_SSL                 = "TRUE"
  #     INSTALL_ADDITIONAL_MODULES = "codec_opus,codec_silk,codec_siren7,codec_siren14,CORE-SOUNDS-RU-WAV,CORE-SOUNDS-RU-G722"
  #     RTP_START                  = "10000"
  #     RTP_FINISH                 = "10032"
  #     TLS_CERT                   = "tls.crt"
  #     TLS_KEY                    = "tls.key"
  #     HTTPS_PORT                 = "4433"
  #     HTTP_PORT                  = "8081"
  #     DB_EMBEDDED                = "false"
  #     ENABLE_FAIL2BAN            = "TRUE"
  #   })
  ports = tomap({
    pjsip = {
      number   = 5060
      protocol = "UDP"
    }
    pjsip-secure = {
      number   = 5161
      protocol = "UDP"
    }
    https = {
      number   = 4433
      protocol = "TCP"
    }
    http = {
      number   = 8081
      protocol = "TCP"
    }
    rtp1 = {
      number   = 10000
      protocol = "UDP"
    }
    rtp2 = {
      number   = 10001
      protocol = "UDP"
    }
    rtp3 = {
      number   = 10002
      protocol = "UDP"
    }
    rtp4 = {
      number   = 10003
      protocol = "UDP"
    }
    rtp5 = {
      number   = 10004
      protocol = "UDP"
    }
    rtp6 = {
      number   = 10005
      protocol = "UDP"
    }
    rtp7 = {
      number   = 10006
      protocol = "UDP"
    }
    rtp8 = {
      number   = 10007
      protocol = "UDP"
    }
    rtp9 = {
      number   = 10008
      protocol = "UDP"
    }
    rtp10 = {
      number   = 10009
      protocol = "UDP"
    }
    # rtp11 = {
    #   number   = 10010
    #   protocol = "UDP"
    # }
    rtp12 = {
      number   = 10011
      protocol = "UDP"
    }
    rtp13 = {
      number   = 10012
      protocol = "UDP"
    }
    rtp14 = {
      number   = 10013
      protocol = "UDP"
    }
    rtp15 = {
      number   = 10014
      protocol = "UDP"
    }
    rtp16 = {
      number   = 10015
      protocol = "UDP"
    }
    rtp17 = {
      number   = 10016
      protocol = "UDP"
    }
    rtp18 = {
      number   = 10017
      protocol = "UDP"
    }
    rtp19 = {
      number   = 10018
      protocol = "UDP"
    }
    rtp20 = {
      number   = 10019
      protocol = "UDP"
    }
    rtp21 = {
      number   = 10020
      protocol = "UDP"
    }
    rtp22 = {
      number   = 10021
      protocol = "UDP"
    }
    rtp23 = {
      number   = 10022
      protocol = "UDP"
    }
    rtp24 = {
      number   = 10023
      protocol = "UDP"
    }
    rtp25 = {
      number   = 10024
      protocol = "UDP"
    }
    rtp26 = {
      number   = 10025
      protocol = "UDP"
    }
    rtp27 = {
      number   = 10026
      protocol = "UDP"
    }
    rtp28 = {
      number   = 10027
      protocol = "UDP"
    }
    rtp29 = {
      number   = 10028
      protocol = "UDP"
    }
    rt30 = {
      number   = 10029
      protocol = "UDP"
    }
    rt31 = {
      number   = 10030
      protocol = "UDP"
    }
    rt32 = {
      number   = 10031
      protocol = "UDP"
    }
    rt33 = {
      number   = 10032
      protocol = "UDP"
    }
    flash = {
      number   = 4445
      protocol = "TCP"
    }
  })
  #   claims = tomap({
  #     data = {
  #       storage = "5Gi"
  #       path    = "/data"
  #     }
  #     www = {
  #       storage = "2Gi"
  #       path    = "/var/www/html"
  #     }
  #     assets = {
  #       storage = "1Gi"
  #       path    = "/assets/custom"
  #     }
  #   })
}
