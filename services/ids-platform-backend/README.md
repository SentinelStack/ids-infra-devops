# IDS Platform Backend Service

The IDS platform backend is currently the main deployed platform component.

This folder contains deployment assets for running the IDS platform backend on QA and later production.

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
/opt/ids-platform/ids-platform-backend/
├── releases/
├── current -> releases/<release-id>
├── shared/
│   └── ids-platform-backend.env
└── logs/
```

## Runtime User

Recommended Linux user:

```text
ids-platform-backend
```

The service should not run as root.

