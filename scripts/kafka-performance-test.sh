#!/bin/bash
# Kafka producer/consumer performance test
BOOTSTRAP="${KAFKA_BOOTSTRAP:-localhost:9092}"
TOPIC="perf-test-$(date +%s)"
MSGS=1000000
MSG_SIZE=1024

echo "Creating test topic..."
kafka-topics.sh --bootstrap-server "$BOOTSTRAP" --create     --topic "$TOPIC" --partitions 6 --replication-factor 1

echo "Producer test ($MSGS messages, ${MSG_SIZE}B each)..."
kafka-producer-perf-test.sh     --topic "$TOPIC"     --num-records "$MSGS"     --record-size "$MSG_SIZE"     --throughput -1     --producer-props bootstrap.servers="$BOOTSTRAP"

echo "Consumer test..."
kafka-consumer-perf-test.sh     --bootstrap-server "$BOOTSTRAP"     --topic "$TOPIC"     --messages "$MSGS"

kafka-topics.sh --bootstrap-server "$BOOTSTRAP" --delete --topic "$TOPIC"
