ui = true

# Vault API address (use private IP for internal access)
api_addr = "http://10.0.0.11:8200"

storage "file" {
  path = "/opt/vault/data"
}

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = 1
}