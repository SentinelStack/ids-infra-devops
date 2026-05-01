# Backend Integration

This note records the current operational configuration discovered in the `ids-platform-backend` repository.

## Backend Repository

Path inspected locally:

```text
/Users/georgelupu/Desktop/Licenta/ids-platform-backend
```

## Application Facts

```text
groupId: ro.puk3p.sentinel
artifactId: ids-platform-backend
version: 1.0.0
runtime port: 8082
QA URL: https://qa-api.puk3p.online
QA ping endpoint: /test/ping
QA bundled contract endpoint: /test/contract/bundled
```

The backend is currently a minimal Kotlin Spring Boot service used to verify:

- startup
- Nexus dependency resolution
- loading the `ids-api-contract` artifact
- exposing contract validation endpoints

## Current Backend Workflow

The backend GitHub Actions workflow currently:

- builds with Maven using JDK 21
- runs tests
- runs Checkstyle, PMD, and SpotBugs
- packages the Spring Boot JAR
- deploys artifacts to Nexus on push to `main`
- optionally deploys to QA through `workflow_dispatch`
- restarts the `ids-platform-backend` systemd service
- checks `https://qa-api.puk3p.online/test/ping`
- checks `https://qa-api.puk3p.online/test/contract/bundled`
- optionally runs CATS against QA
- optionally publishes CATS HTML output to GitHub Pages

## Current Deployment Defaults

The backend workflow currently defaults to:

```text
QA_DEPLOY_PATH=/opt/ids-platform-backend
QA_SERVICE_NAME=ids-platform-backend
deployed jar name: app.jar
```

## Infra Recommendation

Keep the backend repository responsible for:

- source code
- Maven build
- quality gates
- artifact publishing
- workflow trigger logic

Keep this infra repository responsible for:

- the documented deployment model
- systemd and Nginx templates
- server directory conventions
- reusable deploy scripts
- runbooks
- secrets and SSH policy

## Recommended Server Layout Migration

The backend workflow currently uses a flat path:

```text
/opt/ids-platform-backend/app.jar
```

For cleaner rollback and future multi-service support, prefer migrating QA to:

```text
/opt/ids-platform/ids-platform-backend/
├── releases/
├── current
├── shared/
│   └── ids-platform-backend.env
└── logs/
```

This infra repo now uses the cleaner layout in its templates and scripts. The backend workflow can later be updated to call these scripts or reproduce this release layout.

