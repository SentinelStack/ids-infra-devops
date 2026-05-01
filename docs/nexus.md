# Nexus

Nexus is the artifact storage layer between application builds and deployments.

## Current Role

The backend repository builds the Maven artifact and publishes it to Nexus.

The QA deployment flow should deploy an artifact from Nexus instead of rebuilding on the server.

## Why This Matters

Deploying the exact artifact produced by CI gives you:

- reproducible QA deployments
- clearer release history
- easier rollback
- a clean separation between build and deploy

## Repository Boundary

Backend repository:

- Maven build
- tests
- artifact publishing

Infra repository:

- deployment documentation
- artifact naming convention
- deployment scripts/templates
- rollback expectations

