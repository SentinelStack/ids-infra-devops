#!/usr/bin/env bash
#
# vps-apply.sh <service> <environment>
#
# GitOps "apply" run ON the host: pull the latest infra config, render the
# service EnvironmentFile from Vault, ship the central application.yml, and
# restart the systemd service. Idempotent — safe to run on every deploy.
#
# Expects, on the host:
#   - this repo cloned at the location it runs from (e.g. /opt/ids-infra-devops)
#   - /etc/sentinel/vault.env with VAULT_ADDR / VAULT_TOKEN (scoped read token)
#   - the deploy artifact already placed at /opt/<service>/<jar> (by the deploy)
#   - privileges to run systemctl (root, or invoked via sudo)

set -euo pipefail

SERVICE="${1:?usage: vps-apply.sh <service> <environment>}"
ENVIRONMENT="${2:?usage: vps-apply.sh <service> <environment>}"

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEPLOY_PATH="/opt/${SERVICE}"
VAULT_ENV="/etc/sentinel/vault.env"
ENV_FILE="${DEPLOY_PATH}/${SERVICE}.env"
APP_YML="${REPO_ROOT}/config/services/${SERVICE}/application.yml"

log() { echo "[vps-apply] $*"; }

log "pulling latest infra config..."
git -C "${REPO_ROOT}" pull --ff-only

log "rendering ${SERVICE} env from Vault (${ENVIRONMENT})..."
[ -f "${VAULT_ENV}" ] || { echo "[vps-apply] missing ${VAULT_ENV}" >&2; exit 1; }
# shellcheck disable=SC1090
set -a; . "${VAULT_ENV}"; set +a
"${REPO_ROOT}/scripts/render-env-from-vault.sh" "${SERVICE}" "${ENVIRONMENT}" "${ENV_FILE}"

if [ -f "${APP_YML}" ]; then
  log "shipping central application.yml..."
  install -m 0644 "${APP_YML}" "${DEPLOY_PATH}/application.yml"
fi

log "restarting ${SERVICE}..."
systemctl restart "${SERVICE}"
sleep 2
if systemctl is-active --quiet "${SERVICE}"; then
  log "${SERVICE} is active."
else
  echo "[vps-apply] ${SERVICE} failed to start:" >&2
  journalctl -u "${SERVICE}" -n 20 --no-pager >&2 || true
  exit 1
fi
