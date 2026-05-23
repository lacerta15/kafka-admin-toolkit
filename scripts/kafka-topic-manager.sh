#!/bin/bash
# Kafka topic management utility
BOOTSTRAP="${KAFKA_BOOTSTRAP:-localhost:9092}"
ACTION="${1:-list}"

case "$ACTION" in
    list)
        kafka-topics.sh --bootstrap-server "$BOOTSTRAP" --list
        ;;
    describe)
        kafka-topics.sh --bootstrap-server "$BOOTSTRAP" --describe --topic "${2:?topic required}"
        ;;
    create)
        kafka-topics.sh --bootstrap-server "$BOOTSTRAP" --create             --topic "${2:?topic}"             --partitions "${3:-3}"             --replication-factor "${4:-2}"
        ;;
    delete)
        kafka-topics.sh --bootstrap-server "$BOOTSTRAP" --delete --topic "${2:?topic}"
        ;;
    lag)
        kafka-consumer-groups.sh --bootstrap-server "$BOOTSTRAP"             --describe --all-groups | column -t
        ;;
    *)
        echo "Usage: $0 {list|describe|create|delete|lag} [topic] [partitions] [replication]"
        ;;
esac
