# Read-only access to all Sentinel service secrets, for the deploy/render token
# used by scripts/render-env-from-vault.sh on the VPS.
#
#   vault policy write sentinel-deploy-read config/vault/policies/sentinel-deploy-read.hcl

path "secret/data/sentinel/*" {
  capabilities = ["read"]
}

path "secret/metadata/sentinel/*" {
  capabilities = ["read", "list"]
}
