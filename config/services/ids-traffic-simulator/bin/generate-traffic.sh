#!/usr/bin/env bash
#
# Demo telemetry generator: registers an edge device and continuously feeds the
# backend with realistic traffic-stat windows, packet summaries, heartbeats and
# alerts, so the dashboard and /traffic page (and the Kafka -> Flink -> S3
# pipeline) show live, rolling data. Everything auto-expires via the MongoDB
# TTL indexes, so the data set stays fresh.
#
# Config via env:
#   BACKEND_URL, DEVICE_ID, DEVICE_NAME, DEVICE_IP,
#   TICK_SECONDS              (traffic + packets cadence; default 20)
#   PACKETS_PER_TICK          (default 4)
#   ALERT_INTERVAL_SECONDS    (one alert every N seconds; default 72 = 50/hour)
#   HEARTBEAT_EVERY_TICKS     (default 3)

set -euo pipefail

BACKEND_URL="${BACKEND_URL:-http://localhost:8082}"
DEVICE_ID="${DEVICE_ID:-edge-router-01}"
DEVICE_NAME="${DEVICE_NAME:-Edge Router 01}"
DEVICE_IP="${DEVICE_IP:-192.168.1.1}"
TICK="${TICK_SECONDS:-20}"
PACKETS_PER_TICK="${PACKETS_PER_TICK:-4}"
# Backwards compatible with the old INTERVAL_SECONDS knob.
ALERT_INTERVAL="${ALERT_INTERVAL_SECONDS:-${INTERVAL_SECONDS:-72}}"
HEARTBEAT_EVERY="${HEARTBEAT_EVERY_TICKS:-3}"

# Real, geolocatable public IPs across countries (external peers / attackers).
EXT_IPS=(
  8.8.8.8 77.88.8.8 114.114.114.114 1.1.1.1 9.9.9.9 208.67.222.222
  80.80.80.80 84.200.69.80 195.46.39.39 200.160.2.3 212.58.224.0
  194.25.0.60 168.126.63.1 156.154.70.1 80.67.169.12 1.0.0.1
)
ALERT_TYPES=(PORT_SCAN_SUSPECTED UDP_FLOOD_SUSPECTED TCP_SPIKE_SUSPECTED HIGH_TRAFFIC_VOLUME)
SEVERITIES=(LOW MEDIUM MEDIUM HIGH HIGH CRITICAL)
PROTOCOLS=(TCP TCP TCP UDP UDP ICMP)
OUT_PORTS=(443 443 80 53)
IN_PORTS=(443 22 3389 8080 23)

log() { echo "[traffic-sim] $*"; }

post() { # method path json
  curl -s -o /dev/null -w '%{http_code}' -X "$1" "${BACKEND_URL}$2" \
    -H 'Content-Type: application/json' -d "$3" 2>/dev/null || echo 000
}

register_device() {
  local body
  body="$(printf '{"deviceId":"%s","name":"%s","ipAddress":"%s","firmwareVersion":"23.05.3","model":"Sentinel Edge"}' \
    "$DEVICE_ID" "$DEVICE_NAME" "$DEVICE_IP")"
  local code; code="$(post POST /api/devices/register "$body")"
  log "register device ${DEVICE_ID} -> ${code}"
}

emit_traffic_stats() {
  local ts="$1"
  local total tcp udp avg tbytes ubytes totalbytes
  total=$((RANDOM % 4000 + 1000))
  tcp=$((total * (RANDOM % 15 + 55) / 100))
  udp=$((total * (RANDOM % 12 + 22) / 100))
  avg=$((RANDOM % 800 + 200))
  tbytes=$((tcp * avg))
  ubytes=$((udp * (avg / 2 + 40)))
  totalbytes=$((total * avg))
  post POST /api/traffic/stats "$(printf '{"deviceId":"%s","timestamp":"%s","totalPackets":%s,"tcpPackets":%s,"udpPackets":%s,"totalBytes":%s,"tcpBytes":%s,"udpBytes":%s,"windowSeconds":%s}' \
    "$DEVICE_ID" "$ts" "$total" "$tcp" "$udp" "$totalbytes" "$tbytes" "$ubytes" "$TICK")" >/dev/null
}

emit_packet() {
  local ts="$1" proto src dst sport dport size
  proto="${PROTOCOLS[$((RANDOM % ${#PROTOCOLS[@]}))]}"
  size=$((RANDOM % 1400 + 60))
  sport=$((RANDOM % 60000 + 1024))
  if (( RANDOM % 10 < 7 )); then
    src="192.168.1.$((RANDOM % 50 + 10))"
    dst="${EXT_IPS[$((RANDOM % ${#EXT_IPS[@]}))]}"
    dport="${OUT_PORTS[$((RANDOM % ${#OUT_PORTS[@]}))]}"
  else
    src="${EXT_IPS[$((RANDOM % ${#EXT_IPS[@]}))]}"
    dst="192.168.1.$((RANDOM % 5 + 250))"
    dport="${IN_PORTS[$((RANDOM % ${#IN_PORTS[@]}))]}"
  fi
  post POST /api/forensics/packets "$(printf '{"deviceId":"%s","timestamp":"%s","protocol":"%s","sourceIp":"%s","destinationIp":"%s","sourcePort":%s,"destinationPort":%s,"packetSize":%s}' \
    "$DEVICE_ID" "$ts" "$proto" "$src" "$dst" "$sport" "$dport" "$size")" >/dev/null
}

emit_alert() {
  local ts="$1" ip type sev proto dport
  ip="${EXT_IPS[$((RANDOM % ${#EXT_IPS[@]}))]}"
  type="${ALERT_TYPES[$((RANDOM % ${#ALERT_TYPES[@]}))]}"
  sev="${SEVERITIES[$((RANDOM % ${#SEVERITIES[@]}))]}"
  proto="${PROTOCOLS[$((RANDOM % ${#PROTOCOLS[@]}))]}"
  dport="${IN_PORTS[$((RANDOM % ${#IN_PORTS[@]}))]}"
  post POST /api/alerts "$(printf '{"deviceId":"%s","timestamp":"%s","type":"%s","severity":"%s","protocol":"%s","sourceIp":"%s","destinationIp":"192.168.1.%s","sourcePort":%s,"destinationPort":%s,"packetCount":%s,"bytesCount":%s,"windowSeconds":5,"description":"simulated edge traffic"}' \
    "$DEVICE_ID" "$ts" "$type" "$sev" "$proto" "$ip" "$((RANDOM % 50 + 2))" "$((RANDOM % 60000 + 1024))" "$dport" "$((RANDOM % 1500 + 20))" "$((RANDOM % 2000000 + 5000))")" >/dev/null
}

log "starting: backend=${BACKEND_URL} tick=${TICK}s packets/tick=${PACKETS_PER_TICK} alert_every=${ALERT_INTERVAL}s"
register_device

tick=0
last_alert=0
while true; do
  now="$(date +%s)"
  ts="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  tick=$((tick + 1))

  emit_traffic_stats "$ts"
  for _ in $(seq 1 "$PACKETS_PER_TICK"); do
    emit_packet "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  done

  if (( tick % HEARTBEAT_EVERY == 0 )); then
    post POST "/api/devices/${DEVICE_ID}/heartbeat" "{\"seenAt\":\"${ts}\"}" >/dev/null
  fi

  if (( now - last_alert >= ALERT_INTERVAL )); then
    emit_alert "$ts"
    last_alert="$now"
  fi

  sleep "$TICK"
done
