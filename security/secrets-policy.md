# Secrets Policy

Secrets must live outside Git.

Use GitHub Actions secrets for CI/CD and deployment credentials.

Use host-local environment files for runtime secrets:

```text
/opt/ids-platform/<service>/shared/<service>.env
```

Every committed env file must be an example file and must contain placeholder values only.

