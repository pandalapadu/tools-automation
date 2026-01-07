provider "vault" {
  address = "http://vault-internal.azdevopsb82.online:8200"
  #address = "http://10.1.0.8:8200"
  token   = var.token
}
variable "token" {}