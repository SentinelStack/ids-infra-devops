# Secrets

Secrets must not be committed to this repository.

## Where Secrets Belong

Use GitHub Actions secrets for CI/CD values:

- SSH private key for QA deployment
- QA host
- QA user
- Nexus credentials
- API tokens
- deployment-specific URLs

Use files on the target server for runtime service secrets:

```text
/opt/ids-platform/ids-platform-backend/shared/ids-platform-backend.env
```

## What Can Be Committed

Safe to commit:

- `*.example`
- `*.template`
- documentation
- scripts with placeholder variables

Unsafe to commit:

- real `.env` files
- private keys
- TLS private keys
- passwords
- tokens
- server-specific secret overrides

## Naming Convention

Example files:

```text
ids-platform-backend.env.example
service.env.example
```

Real files:

```text
ids-platform-backend.env
```

Real files must remain outside Git.

