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
services/ids-platform-backend/deploy/rollback-ids-platform-backend.sh 20260501120000
services/ids-platform-backend/deploy/healthcheck-ids-platform-backend.sh https://qa-api.puk3p.online
```

