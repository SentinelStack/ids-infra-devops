# Nexus Publishing

Nexus stores backend build artifacts produced by the backend repository.

## Suggested Maven Coordinates

```text
groupId: ro.licenta.ids
artifactId: ids-backend-api
version: 1.0.0-SNAPSHOT or release version
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

