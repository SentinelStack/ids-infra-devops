# ClickHouse (Sentinel)

Analytical store for the alert data, consumed live from Kafka and queried by
`ids-download-report`. Runs on the VPS, **localhost-only** (HTTP 8123, native
9000); public read access is via the `clickhouse.puk3p.online` Play UI behind
nginx + TLS.

```
ids.alerts (Kafka) -> Kafka engine -> materialized view -> sentinel.alerts (MergeTree)
                                                                  ^
ids-download-report --JDBC (report_app, SELECT)-------------------+
```

## Files
| Path | Purpose |
|---|---|
| `config.d/zz-sentinel.xml` | Memory cap + Kafka `auto_offset_reset=earliest`. No secrets. |
| `users.d/zz-sentinel.xml.example` | `default` (admin) + `sentinel` (read-only UI) users. Fill SHA256 placeholders from Vault before installing. |
| `schema.sql` | Database, MergeTree table, Kafka engine, materialized view, and the SELECT-only `report_app` user. |

## Provision (fresh box)
```bash
# 1. Install (static binary; apt keyserver is blocked on this host)
curl https://clickhouse.com/ | sh && ./clickhouse install --noninteractive

# 2. Server + users config
install -m644 config.d/zz-sentinel.xml /etc/clickhouse-server/config.d/
#    copy users.d/zz-sentinel.xml.example -> users.d/zz-sentinel.xml and replace
#    __DEFAULT_PASSWORD_SHA256__ / __SENTINEL_PASSWORD_SHA256__ with:
#      printf '%s' "$PW" | sha256sum | cut -d' ' -f1
chown -R clickhouse:clickhouse /etc/clickhouse-server
systemctl enable --now clickhouse-server

# 3. Schema + app user (replace __REPORT_APP_PASSWORD__ with the Vault value)
clickhouse-client --user default --password "$ADMIN_PW" --multiquery < schema.sql
```

Passwords (admin, `sentinel`, `report_app`/`CLICKHOUSE_PASSWORD`) live in Vault,
not in this repo. The public UI vhost is managed by certbot/nginx
(`clickhouse.puk3p.online`).
