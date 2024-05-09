provider "helm" {
  kubernetes {
    host                   = var.kubernetes.host
    client_certificate     = var.kubernetes.cert
    client_key             = var.kubernetes.key
    cluster_ca_certificate = var.kubernetes.ca
  }
}

provider "kubernetes" {
  host                   = var.kubernetes.host
  client_certificate     = var.kubernetes.cert
  client_key             = var.kubernetes.key
  cluster_ca_certificate = var.kubernetes.ca
}

provider "vault" {
  address = var.vault.host
  token   = var.vault.token
}

provider "cloudflare" {
  api_token = var.cloudflare.token
}

resource "vault_mount" "api_providers" {
  type        = "kv"
  path        = "api_providers"
  options     = { version = "2" }
  description = "api providers secrets"
}

resource "vault_kv_secret_v2" "cloudflare" {
  mount     = vault_mount.api_providers.path
  name      = "cloudflare"
  data_json = jsonencode(var.cloudflare)
}

