#!/bin/bash
# Monitor consumer group lag and alert if > threshold
BOOTSTRAP="${KAFKA_BOOTSTRAP:-localhost:9092}"
LAG_THRESHOLD="${LAG_THRESHOLD:-1000}"

echo "=== Kafka Consumer Lag Report ==="
kafka-consumer-groups.sh --bootstrap-server "$BOOTSTRAP" --describe --all-groups 2>/dev/null     | awk -v threshold="$LAG_THRESHOLD" '
    NR>1 && $NF ~ /^[0-9]+$/ && $NF > threshold {
        printf "[WARN] Group: %-30s Topic: %-30s Lag: %s\n", $1, $2, $NF
    }'
