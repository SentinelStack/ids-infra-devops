#!/usr/bin/env bash
set -euo pipefail

SERVICE_NAME="ids-platform-backend"
APP_DIR="/opt/ids-platform/${SERVICE_NAME}"
RELEASES_DIR="${APP_DIR}/releases"
CURRENT_LINK="${APP_DIR}/current"
ARTIFACT_PATH="${1:-}"
RELEASE_ID="${2:-$(date -u +%Y%m%d%H%M%S)}"

if [[ -z "${ARTIFACT_PATH}" ]]; then
  echo "Usage: $0 /path/to/ids-platform-backend.jar [release-id]" >&2
  exit 1
fi

if [[ ! -f "${ARTIFACT_PATH}" ]]; then
  echo "Artifact not found: ${ARTIFACT_PATH}" >&2
  exit 1
fi

RELEASE_DIR="${RELEASES_DIR}/${RELEASE_ID}"

mkdir -p "${RELEASE_DIR}"
cp "${ARTIFACT_PATH}" "${RELEASE_DIR}/ids-platform-backend.jar"
ln -sfn "${RELEASE_DIR}" "${CURRENT_LINK}"

sudo systemctl restart "${SERVICE_NAME}"
sudo systemctl --no-pager status "${SERVICE_NAME}"

echo "Deployed ${SERVICE_NAME} release ${RELEASE_ID}"

