# QA Deployment Automation

QA deployment is currently SSH based.

Recommended approach:

- GitHub Actions authenticates using a dedicated deployment key
- deployment user has limited sudo permissions
- artifact is downloaded from Nexus or copied to the QA server
- deployment script creates a release directory
- `current` symlink is updated
- systemd restarts the backend API
- health check verifies the deployment

