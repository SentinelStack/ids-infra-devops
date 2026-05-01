# QA Deployment

## Trigger

QA deployment can be automatic after successful backend CI or manual through `workflow_dispatch`.

For a bachelor thesis project, a good balance is:

- automatic deployment from the main backend branch to QA
- manual rerun support for failed infrastructure steps
- CATS run after the QA health check passes

## Required GitHub Secrets

Use names similar to:

```text
QA_SSH_HOST
QA_SSH_USER
QA_SSH_PRIVATE_KEY
QA_IDS_PLATFORM_BACKEND_URL
NEXUS_URL
NEXUS_USERNAME
NEXUS_PASSWORD
```

## Server Commands

The deployment user should be allowed to restart only the required service:

```text
sudo systemctl restart ids-platform-backend
sudo systemctl status ids-platform-backend
```

Avoid giving the deployment user unrestricted sudo access.

