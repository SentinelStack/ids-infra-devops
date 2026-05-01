# Backend API Service

The backend API is currently the main deployed platform component.

This folder contains deployment assets for running the backend API on QA and later production.

## Contents

```text
env/       # environment file examples
systemd/   # systemd service templates
nginx/     # reverse proxy templates
deploy/    # deployment and operations helper scripts
runbooks/  # troubleshooting and operational notes
```

## Runtime Layout

Recommended QA server layout:

```text
/opt/ids-platform/backend-api/
├── releases/
├── current -> releases/<release-id>
├── shared/
│   └── backend-api.env
└── logs/
```

## Runtime User

Recommended Linux user:

```text
ids-backend
```

The service should not run as root.

