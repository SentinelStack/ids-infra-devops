#!/usr/bin/env bash
set -euo pipefail

SERVICE_NAME="backend-api"
APP_DIR="/opt/ids-platform/${SERVICE_NAME}"
RELEASES_DIR="${APP_DIR}/releases"
CURRENT_LINK="${APP_DIR}/current"
TARGET_RELEASE="${1:-}"

if [[ -z "${TARGET_RELEASE}" ]]; then
  echo "Usage: $0 <release-directory-name>" >&2
  echo "Available releases:" >&2
  ls -1 "${RELEASES_DIR}" >&2
  exit 1
fi

TARGET_DIR="${RELEASES_DIR}/${TARGET_RELEASE}"

if [[ ! -d "${TARGET_DIR}" ]]; then
  echo "Release not found: ${TARGET_DIR}" >&2
  exit 1
fi

ln -sfn "${TARGET_DIR}" "${CURRENT_LINK}"
sudo systemctl restart "${SERVICE_NAME}"
sudo systemctl --no-pager status "${SERVICE_NAME}"

echo "Rolled back ${SERVICE_NAME} to ${TARGET_RELEASE}"

