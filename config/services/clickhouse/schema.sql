-- Sentinel ClickHouse bootstrap. Apply once with the admin (default) user:
--   clickhouse-client --user default --password "$ADMIN_PW" --multiquery < schema.sql
--
-- Alerts are streamed in live from Kafka: Kafka engine -> materialized view ->
-- MergeTree. The ids-download-report service reads the `alerts` table.

CREATE DATABASE IF NOT EXISTS sentinel;

-- Target table: the queryable alert store.
CREATE TABLE IF NOT EXISTS sentinel.alerts (
    alertId String,
    deviceId String,
    timestamp DateTime,
    type LowCardinality(String),
    severity LowCardinality(String),
    protocol LowCardinality(String),
    sourceIp String,
    destinationIp String,
    sourcePort UInt16,
    destinationPort UInt16,
    packetCount UInt64,
    bytesCount UInt64,
    windowSeconds UInt32,
    description String,
    acknowledged UInt8,
    createdAt DateTime,
    dt Date MATERIALIZED toDate(timestamp)
)
ENGINE = MergeTree
PARTITION BY toYYYYMMDD(timestamp)
ORDER BY (timestamp, severity);

-- Kafka engine: consumes the ids.alerts topic (JSON). auto_offset_reset=earliest
-- is set in config.d/zz-sentinel.xml so it backfills the retained topic.
CREATE TABLE IF NOT EXISTS sentinel.alerts_kafka (
    alertId String, deviceId String, timestamp String, type String, severity String,
    protocol String, sourceIp String, destinationIp String, sourcePort UInt16,
    destinationPort UInt16, packetCount UInt64, bytesCount UInt64, windowSeconds UInt32,
    description String, acknowledged Bool, createdAt String
)
ENGINE = Kafka
SETTINGS
    kafka_broker_list = 'localhost:9092',
    kafka_topic_list = 'ids.alerts',
    kafka_group_name = 'clickhouse-alerts',
    kafka_format = 'JSONEachRow',
    kafka_num_consumers = 1,
    kafka_skip_broken_messages = 100,
    input_format_skip_unknown_fields = 1,
    date_time_input_format = 'best_effort';

-- Materialized view: parse timestamps and feed the MergeTree.
CREATE MATERIALIZED VIEW IF NOT EXISTS sentinel.alerts_mv TO sentinel.alerts AS
SELECT
    alertId, deviceId,
    parseDateTimeBestEffortOrZero(timestamp) AS timestamp,
    type, severity, protocol, sourceIp, destinationIp,
    sourcePort, destinationPort, packetCount, bytesCount, windowSeconds,
    description,
    toUInt8(acknowledged) AS acknowledged,
    parseDateTimeBestEffortOrZero(createdAt) AS createdAt
FROM sentinel.alerts_kafka;

-- SELECT-only application user for ids-download-report (RBAC, no readonly profile
-- so the JDBC driver's setReadOnly works). Replace the password with the Vault
-- value (secret/sentinel/ids-download-report/qa : CLICKHOUSE_PASSWORD).
CREATE USER IF NOT EXISTS report_app IDENTIFIED BY '__REPORT_APP_PASSWORD__';
GRANT SELECT ON sentinel.* TO report_app;
