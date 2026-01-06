module "vm" {
  for_each = var.tools
  source       = "./vm-module"
  component    = each.key
  ssh_password = var.ssh_password
  ssh_username = var.ssh_username
  port       = each.value["port"]
}
variable "tools" {
  default = {
    vault = {
      port = 8200
    }
  }
}
variable "ssh_username" {}
variable "ssh_password" {}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.49"
    }
  }
}
provider "azurerm" {
  features {}
  subscription_id = "af504235-2f6d-4469-aa25-251f498730fc"
}
terraform {
  backend "azurerm" {
    resource_group_name = "eCommerce"
    storage_account_name = "azdevopsvenkat"
    container_name = "tools-tfstate"
    key = "tools.tfstate"
  }
}