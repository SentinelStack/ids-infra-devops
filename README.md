# IDS Infra DevOps

Operational repository for the intelligent IDS/IPS bachelor thesis platform.

This repository contains deployment conventions, environment documentation, server configuration templates, operational runbooks, and reusable infrastructure patterns for the platform. Application source code remains in the service repositories, such as the backend API repository.

## Platform Context

The project is an intelligent IDS/IPS platform with an OpenWrt edge-agent and a backend-first architecture.

Current operational focus:

- backend API deployment to QA
- Maven artifact publishing to Nexus
- GitHub Actions based CI/CD
- SSH based QA deployment
- CATS contract/API fuzz testing against QA
- DNS and HTTPS setup for exposed services

Future components may include:

- frontend web application
- OpenWrt edge-agent delivery/update flow
- AI analysis workers
- MISP threat intelligence integration
- object storage for PCAPs, reports, exports, or datasets
- historical analytics and reporting

## Repository Layout

```text
.
├── docs/              # Architecture and operational explanations
├── environments/      # Environment-specific notes and config examples
├── services/          # Per-service deployment assets and runbooks
├── ci-cd/             # GitHub Actions, Nexus, CATS, and release docs
├── ops/               # Logs, health checks, rollback, and maintenance notes
├── provisioning/      # Server bootstrap and host conventions
├── security/          # Secrets, SSH, TLS, and hardening policies
├── templates/         # Reusable service templates
└── scripts/           # Small generic helper scripts
```

## Environments

The repository uses three stable environment names:

- `local` for developer machines and local experiments
- `qa` for the hosted integration/test environment
- `prod` for future production readiness

QA is the primary active environment today. Production documentation exists so the system can evolve cleanly without adding production complexity too early.

## Service Naming

Services use kebab-case and should keep the same name across folders, systemd units, environment files, reverse proxy configs, and scripts.

Examples:

- `backend-api`
- `frontend`
- `edge-agent`
- `ai-worker`
- `threat-intel`
- `reporting-worker`

## Secrets Rule

Never commit real secrets.

Commit only:

- `*.example`
- `*.template`
- documentation
- scripts without embedded credentials

Real environment files should live on the target host, in GitHub Actions secrets, or in another secret store later.

## First Operational Target

The first supported deployment target is:

```text
GitHub Actions -> Maven build -> Nexus artifact -> SSH deploy to QA -> systemd restart -> health check -> CATS against QA
```

See:

- [Deployment Flow](docs/deployment-flow.md)
- [Environment Model](docs/environments.md)
- [QA Environment](environments/qa/README.md)
- [Backend API Service](services/backend-api/README.md)
- [Nexus](docs/nexus.md)
- [CATS Testing](ci-cd/cats-testing.md)
