# Health Checks

The IDS platform backend should expose a stable health endpoint.

Recommended path:

```text
/actuator/health
```

QA deployment should fail if the health check fails after restart.

Example:

```bash
services/ids-platform-backend/deploy/healthcheck-ids-platform-backend.sh https://qa-api.puk3p.online
```

