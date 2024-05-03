resource "kubernetes_namespace" "mariadb" {
  metadata {
    name = "mariadb"
  }
}

resource "random_password" "root-password" {
  length  = 24
  special = false
}

resource "random_password" "passowrd" {
  length  = 16
  special = false
}

resource "helm_release" "mariadb" {
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "mariadb"
  name       = "mariadb"
  namespace  = kubernetes_namespace.mariadb.metadata[0].name
  version    = "18.0.2"
  values = [templatefile("${path.module}/mariadbValues.yml", {
    username     = var.asterisk.username,
    database     = var.asterisk.database,
    rootPassword = random_password.root-password.result
    password     = random_password.passowrd.result
  })]
}

locals {
  implicit_host = "mariadb.mariadb"
  host          = "10.0.0.45"
}

resource "vault_kv_secret_v2" "mariadb" {
  mount = "storage"
  name  = "mariadb"
  data_json = jsonencode({
    username      = var.asterisk.username,
    database      = var.asterisk.database,
    rootPassword  = random_password.root-password.result
    password      = random_password.passowrd.result
    host          = "mairadb.${var.base-domain}"
    implicit_host = local.implicit_host
  })
}
