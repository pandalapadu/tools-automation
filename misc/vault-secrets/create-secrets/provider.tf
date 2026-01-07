provider "vault" {
  address = "http://vault-internal.azdevopsb82.online:8200"
  #address = "http://10.1.0.8:8200"
  token   = var.token
}
provider "azurerm" {
  features {}
  subscription_id = "af504235-2f6d-4469-aa25-251f498730fc"
}
terraform {
  backend "azurerm" {
    resource_group_name = "eCommerce"
    storage_account_name = "azdevopsvenkat"
    container_name = "vault-container"
    key = "vault-key.tfstate"
  }

}
variable "token" {}