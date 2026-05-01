# Environments

The platform uses a small set of stable environment names.

## Names

```text
local
qa
prod
```

Avoid adding extra names until there is a real operational need.

## Local

Used for development on a personal machine.

Local can be looser than hosted environments, but it should still follow the same naming conventions where possible.

## QA

Used for integration testing and thesis demonstrations.

QA is the main operational target today:

- backend deployed over SSH
- artifact sourced from Nexus
- HTTPS exposed through reverse proxy
- CATS tests run against the deployed API

## Production

Production is future-facing for now.

Production should not be enabled until secrets, TLS, rollback, backup, and manual approval are ready.

