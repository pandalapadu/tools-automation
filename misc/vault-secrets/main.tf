module "create-secrets" {
  for_each = var.secrets
  source = "./create-secrets"
  kv_path = each.key
  secrets = each.value
}