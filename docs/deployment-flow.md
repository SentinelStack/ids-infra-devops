# Deployment Flow

## QA Deployment

The recommended QA flow is:

1. Backend repository runs CI in GitHub Actions.
2. Maven builds and tests the backend.
3. The backend artifact is published to Nexus.
4. A deployment workflow connects to the QA server over SSH.
5. The QA server downloads or receives the artifact.
6. The artifact is placed under a versioned release directory.
7. The `current` symlink is switched to the new release.
8. `systemctl restart backend-api` restarts the service.
9. A health check verifies the QA API.
10. CATS runs against the QA API.
11. Optional generated reports are published to GitHub Pages.

## QA Server Release Layout

```text
/opt/ids-platform/
└── backend-api/
    ├── releases/
    │   ├── 2026-05-01-build-123/
    │   └── 2026-05-01-build-124/
    ├── current -> releases/2026-05-01-build-124
    ├── shared/
    │   └── backend-api.env
    └── logs/
```

## Rollback

Rollback should point `current` back to the previous known-good release and restart the service.

This is intentionally simple and understandable for the current project stage.

