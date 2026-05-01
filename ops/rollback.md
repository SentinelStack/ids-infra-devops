# Rollback

Rollback uses the release directory layout on the server.

## Steps

1. List releases.
2. Choose the last known-good release.
3. Point `current` to that release.
4. Restart the service.
5. Run health check.

Example:

```bash
services/backend-api/deploy/rollback-backend-api.sh 20260501120000
services/backend-api/deploy/healthcheck-backend-api.sh https://api.qa.example.com
```

