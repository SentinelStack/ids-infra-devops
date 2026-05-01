# Service Conventions

Use these conventions for every deployable service added to the platform.

## Naming

Use kebab-case:

```text
ids-platform-backend
frontend
edge-agent
ai-worker
```

## Per-Service Folder Shape

```text
services/<service>/
├── README.md
├── env/
├── systemd/
├── nginx/
├── deploy/
└── runbooks/
```

Only create folders that are useful for the service. For example, a static frontend may not need systemd.

## Server Layout

```text
/opt/ids-platform/<service>/
├── releases/
├── current
├── shared/
└── logs/
```

## Config

Commit examples and templates only.

Real runtime config belongs on the server or in the deployment secret store.

