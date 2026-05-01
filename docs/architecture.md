# Infrastructure Architecture

This repository describes the operational side of the IDS/IPS platform.

## Current Shape

```text
Developer / GitHub
        |
        v
Backend repository
        |
        | Maven build and tests
        v
Nexus artifact repository
        |
        | SSH deployment
        v
QA server
        |
        | systemd + reverse proxy
        v
QA API endpoint
        |
        | CATS contract/API fuzz tests
        v
Generated reports
```

## Responsibilities

The application repositories own source code, build logic, and application tests.

This repository owns:

- deployment templates
- environment conventions
- server layout
- reverse proxy examples
- systemd service examples
- runbooks
- operational documentation
- security and secrets rules

## Design Principle

The platform should be simple enough for one person to operate, but structured enough to grow from one backend service into multiple deployable components.

The repo intentionally avoids Kubernetes, Terraform, Ansible, and centralized observability until they become genuinely useful.

