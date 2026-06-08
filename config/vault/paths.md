# Vault Secret Layout

Secrets for Sentinel services live in a KV v2 mount named `secret`, namespaced
per service and environment:

```text
secret/sentinel/<service>/<environment>
```

Environments: `qa`, `prod` (extend as needed).

## Current secrets

| Service               | Path                                          | Keys          |
| --------------------- | --------------------------------------------- | ------------- |
| ids-platform-backend  | `secret/sentinel/ids-platform-backend/<env>`  | `MONGODB_URI` |

To onboard a new server-side service, add `config/services/<service>/vault.manifest.yml`
+ a read policy under `config/vault/policies/`, then add a row above.

Which keys are secret (vs. plain config) is declared per service in
`config/services/<service>/vault.manifest.yml`. Non-secret defaults live in
`config/services/<service>/env/<service>.env.example` and
`config/services/<service>/application.yml`.

## Writing a secret (example, no real values committed)

```bash
# from a seed file (see config/vault/seed/*.example.json)
vault kv put secret/sentinel/ids-platform-backend/qa \
  MONGODB_URI='mongodb://ids_user:CHANGE_ME@127.0.0.1:27017/ids_platform?authSource=ids_platform'
```

## Reading at deploy

`scripts/render-env-from-vault.sh <service> <env> <output-env-file>` reads the
manifest, pulls each secret field from `secret/sentinel/<service>/<env>`, and
writes the systemd EnvironmentFile (0600). The deploy needs `VAULT_ADDR` and a
token/role bound to the matching read policy in `config/vault/policies/`.
