# QA Environment

QA is the active hosted integration environment for the platform.

It is used to validate deployed backend artifacts, run health checks, and execute CATS contract/API fuzz tests against a real endpoint.

## Expected Components

- QA server accessible over SSH from GitHub Actions
- backend API running under systemd
- reverse proxy exposing HTTPS
- runtime env file stored on the server
- Nexus used as the artifact source

## Deployment Summary

```text
GitHub Actions -> Nexus -> SSH QA deploy -> systemd restart -> health check -> CATS
```

See [deployment.md](deployment.md).

