variable "kubernetes" {
  type = object({
    ca   = string
    key  = string
    cert = string
    host = string
  })
}

variable "asterisk" {
  type = object({
    username = string
    database = string
  })
  default = {
    username = "asterisk"
    database = "asterisk"
  }
}

variable "base-domain" {
  type = string
}

variable "issuer" {
  type = string
}

variable "vault" {
  type = object({
    host  = string
    token = string
  })
}
