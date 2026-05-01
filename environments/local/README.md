# Local Environment

The local environment is for developer-machine experiments and integration checks.

Local should not require production-like infrastructure. Keep it small and reproducible.

## Typical Uses

- run backend locally from the backend repository
- test local environment variables
- verify reverse proxy examples if needed
- run local scripts before using QA

## Rules

- do not store real secrets in Git
- do not make local paths required for QA
- keep local overrides separate from committed examples

