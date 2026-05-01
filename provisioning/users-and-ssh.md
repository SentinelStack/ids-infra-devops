# Users and SSH

## Deployment User

Use a dedicated deployment user for GitHub Actions.

Recommended properties:

- SSH key authentication only
- no password login
- limited sudo permissions
- allowed to restart required services only

## Service User

Use a separate service user for running the backend:

```text
ids-platform-backend
```

The service user should not be the same as the SSH deployment user.

