# Vault policy: read-only access to ids-platform-backend secrets.
# Attach to the deploy role/token used by the CI/SSH deploy that renders the
# EnvironmentFile (scripts/render-env-from-vault.sh).
#
# Apply with:
#   vault policy write ids-platform-backend config/vault/policies/ids-platform-backend.hcl

# KV v2 data path (read secret values).
path "secret/data/sentinel/ids-platform-backend/*" {
  capabilities = ["read"]
}

# KV v2 metadata path (list/inspect versions).
path "secret/metadata/sentinel/ids-platform-backend/*" {
  capabilities = ["read", "list"]
}
