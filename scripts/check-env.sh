#!/usr/bin/env bash
set -euo pipefail

required_vars=(
  "QA_SSH_HOST"
  "QA_SSH_USER"
  "NEXUS_URL"
)

missing=0

for var in "${required_vars[@]}"; do
  if [[ -z "${!var:-}" ]]; then
    echo "Missing required variable: ${var}" >&2
    missing=1
  fi
done

exit "${missing}"

