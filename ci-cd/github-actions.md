# GitHub Actions

## Current Role

GitHub Actions should:

- build and test the backend
- publish Maven artifacts to Nexus
- deploy to QA over SSH
- run post-deployment health checks
- run CATS against QA
- publish generated reports when useful

## Current Backend Workflow

The `ids-platform-backend` repository currently has a single workflow:

```text
.github/workflows/backend-ci.yml
```

It builds with Maven, publishes to Nexus on pushes to `main`, supports manual QA deployment, runs QA smoke tests, can run CATS against `https://qa-api.puk3p.online`, and can publish CATS reports to GitHub Pages.

Operational defaults currently used by that workflow:

```text
QA service: ids-platform-backend
QA URL: https://qa-api.puk3p.online
runtime port: 8082
ping endpoint: /test/ping
contract endpoint: /test/contract/bundled
```

## Secret Discipline

All deployment credentials must come from GitHub Actions secrets or protected environments.

Do not hardcode:

- SSH keys
- Nexus credentials
- server addresses if private
- API tokens

## Production Later

Production deployment should use GitHub Environments with manual approval.
