# Health Checks

The backend API should expose a stable health endpoint.

Recommended path:

```text
/actuator/health
```

QA deployment should fail if the health check fails after restart.

Example:

```bash
services/backend-api/deploy/healthcheck-backend-api.sh https://api.qa.example.com
```

