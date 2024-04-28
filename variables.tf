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
    goip = object({
      username = string
      passowrd = string
      endpoint = string
    })
  })
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
