# Nexus Publishing

Nexus stores backend build artifacts produced by the backend repository.

## Suggested Maven Coordinates

```text
groupId: ro.puk3p.sentinel
artifactId: ids-platform-backend
version: 1.0.0
```

Nexus base URL currently used by the backend:

```text
https://nexus.puk3p.online
```

## Infra Repository Role

This repository should document:

- Nexus URL convention
- artifact naming
- which GitHub secrets are required
- how QA deployment selects an artifact
- rollback expectations

The backend repository should own:

- `pom.xml`
- Maven publishing configuration
- build and test workflows
