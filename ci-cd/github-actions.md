# GitHub Actions

## Current Role

GitHub Actions should:

- build and test the backend
- publish Maven artifacts to Nexus
- deploy to QA over SSH
- run post-deployment health checks
- run CATS against QA
- publish generated reports when useful

## Secret Discipline

All deployment credentials must come from GitHub Actions secrets or protected environments.

Do not hardcode:

- SSH keys
- Nexus credentials
- server addresses if private
- API tokens

## Production Later

Production deployment should use GitHub Environments with manual approval.

