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

