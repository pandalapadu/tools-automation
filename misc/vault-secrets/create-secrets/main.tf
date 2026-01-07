terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "5.3.0"
    }
  }
}
resource "vault_mount" "main" {
  for_each = var.secrets
  path      = each.key
  type      = "kv"
}
variable "secrets" {
  default = {
    infra = {}
    roboshop-dev = {}
  }
}