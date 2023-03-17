#!/bin/sh

export OTEL_LOGS_EXPORTER=logging
export OTEL_METRICS_EXPORTER=none
export OTEL_TRACES_EXPORTER=none

for ver in 1.22.1 1.23.0 1.24.0; do
  echo "\n############\n############ Using otel javaagent $ver"
  java -javaagent:/app/otel-${ver}.jar -jar otel-troubleshooting-svr/target/otel-troubleshooting-svr-0.0.1-SNAPSHOT.jar
done
