#!/usr/bin/env bash
set -euo pipefail

host="${1:-}"
user="${2:-}"

if [[ -z "${host}" || -z "${user}" ]]; then
  echo "Usage: $0 <host> <user>" >&2
  exit 1
fi

ssh -o BatchMode=yes -o ConnectTimeout=10 "${user}@${host}" "hostname && whoami"

