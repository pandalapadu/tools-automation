terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "5.3.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.49.0"
    }
  }
}
resource "vault_mount" "main" {
  for_each = var.secrets
  path      = each.key
  type      = "kv"
}

resource "vault_kv_secret" "secret" {
  data_json = ""
  path      = "infra/ssh"
  data_json = jsondecode( var.secrets.infra.ssh)
}

variable "secrets" {
  default = {
    infra = {
      ssh = {
        admin_username = "azureuser"
        admin_password = "azureuser@123"
      }
    }
    roboshop-dev = {}
  }
}