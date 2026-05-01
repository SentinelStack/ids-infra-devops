# Backend Workflow Migration

The backend workflow in `ids-platform-backend` currently works and should stay in the backend repository because it builds and tests that application.

Do not move the entire workflow into this infra repository.

## What Should Change Later

The QA deploy step currently copies the JAR directly to:

```text
/opt/ids-platform-backend/app.jar
```

Recommended target:

```text
/opt/ids-platform/ids-platform-backend/releases/<release-id>/ids-platform-backend.jar
/opt/ids-platform/ids-platform-backend/current -> releases/<release-id>
```

That change gives QA rollback without adding heavy tooling.

## Practical Migration Options

Option A: keep deployment logic in the backend workflow, but update the shell commands to use the release layout documented here.

Option B: checkout this infra repository during the backend workflow and run:

```bash
services/ids-platform-backend/deploy/deploy-ids-platform-backend-qa.sh <jar-path> <release-id>
```

Option A is simpler today. Option B becomes useful when multiple repositories reuse the same deployment scripts.

## Current Values To Preserve

```text
QA service name: ids-platform-backend
QA public URL: https://qa-api.puk3p.online
runtime port: 8082
health check: /test/ping
contract endpoint: /test/contract/bundled
```

