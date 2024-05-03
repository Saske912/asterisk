#install asterisk database with alembic

resource "kubernetes_job_v1" "install-database" {
  depends_on = [helm_release.mariadb]
  metadata {
    name      = "install-database"
    namespace = kubernetes_namespace_v1.asterisk.metadata[0].name
  }
  spec {
    template {
      metadata {
      }
      spec {
        container {
          image       = "saveloy/asterisk:0.7.1"
          name        = "alembic"
          command     = ["/bin/sh"]
          working_dir = "/usr/local/src/asterisk-20.1.0/contrib/ast-db-manage"
          args        = ["-c", "alembic -c ./config.ini upgrade head"]
          volume_mount {
            mount_path = "/usr/local/src/asterisk-20.1.0/contrib/ast-db-manage/config.ini"
            name       = "config"
            sub_path   = "config.ini"
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
        # volume {
        #   name = "odbc"
        #   config_map {
        #     name = kubernetes_config_map_v1.other.metadata[0].name
        #     items {
        #       key  = "MariaDB_odbc_data_source_template.ini"
        #       path = "MariaDB_odbc_data_source_template.ini"
        #     }
        #   }
        # }
        # volume {
        #   name = "odbc-driver"
        #   config_map {
        #     name = kubernetes_config_map_v1.other.metadata[0].name
        #     items {
        #       key  = "MariaDB_odbc_driver_template.ini"
        #       path = "MariaDB_odbc_driver_template.ini"
        #     }
        #   }
        # }
      }
    }
  }
}
