#!/usr/bin/env bash
#
# Demo traffic generator: continuously POSTs realistic alerts to the backend so
# the dashboard (and the Kafka -> Flink -> S3 pipeline) shows live, rolling data.
# Alerts auto-expire via the MongoDB TTL index, so the data set stays fresh.
#
# Config via env: BACKEND_URL, INTERVAL_SECONDS, DEVICE_ID.

set -euo pipefail

BACKEND_URL="${BACKEND_URL:-http://localhost:8082}"
INTERVAL="${INTERVAL_SECONDS:-12}"
DEVICE_ID="${DEVICE_ID:-edge-router-01}"

# Real, geolocatable public IPs spread across countries so the threat map and
# top-origins panel light up globally.
IPS=(
  8.8.8.8 77.88.8.8 114.114.114.114 1.1.1.1 9.9.9.9 208.67.222.222
  80.80.80.80 84.200.69.80 195.46.39.39 200.160.2.3 212.58.224.0
  194.25.0.60 168.126.63.1 156.154.70.1 80.67.169.12 1.0.0.1
)
TYPES=(PORT_SCAN_SUSPECTED UDP_FLOOD_SUSPECTED TCP_SPIKE_SUSPECTED HIGH_TRAFFIC_VOLUME)
SEVERITIES=(LOW MEDIUM MEDIUM HIGH HIGH CRITICAL)
PROTOCOLS=(TCP TCP UDP)
DEST_PORTS=(22 80 443 3389 8080 53)

log() { echo "[traffic-sim] $*"; }
log "starting: backend=${BACKEND_URL} interval=${INTERVAL}s pool=${#IPS[@]} ips"

while true; do
  ip="${IPS[$((RANDOM % ${#IPS[@]}))]}"
  type="${TYPES[$((RANDOM % ${#TYPES[@]}))]}"
  sev="${SEVERITIES[$((RANDOM % ${#SEVERITIES[@]}))]}"
  proto="${PROTOCOLS[$((RANDOM % ${#PROTOCOLS[@]}))]}"
  dport="${DEST_PORTS[$((RANDOM % ${#DEST_PORTS[@]}))]}"
  ts="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  dst="192.168.1.$((RANDOM % 50 + 2))"

  body="$(printf '{"deviceId":"%s","timestamp":"%s","type":"%s","severity":"%s","protocol":"%s","sourceIp":"%s","destinationIp":"%s","sourcePort":%s,"destinationPort":%s,"packetCount":%s,"bytesCount":%s,"windowSeconds":5,"description":"simulated edge traffic"}' \
    "$DEVICE_ID" "$ts" "$type" "$sev" "$proto" "$ip" "$dst" \
    "$((RANDOM % 60000 + 1024))" "$dport" "$((RANDOM % 1500 + 20))" "$((RANDOM % 2000000 + 5000))")"

  code="$(curl -s -o /dev/null -w '%{http_code}' -X POST "${BACKEND_URL}/api/alerts" \
    -H 'Content-Type: application/json' -d "$body" || echo 000)"
  if [ "$code" != "201" ]; then
    log "POST -> ${code} (ip=${ip})"
  fi

  sleep "$INTERVAL"
done
