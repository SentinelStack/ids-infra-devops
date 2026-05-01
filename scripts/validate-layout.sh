#!/usr/bin/env bash
set -euo pipefail

required_paths=(
  "docs"
  "environments/local"
  "environments/qa"
  "environments/prod"
  "services/ids-platform-backend"
  "ci-cd"
  "ops"
  "provisioning"
  "security"
)

for path in "${required_paths[@]}"; do
  if [[ ! -e "${path}" ]]; then
    echo "Missing required path: ${path}" >&2
    exit 1
  fi
done

echo "Repository layout looks valid."

