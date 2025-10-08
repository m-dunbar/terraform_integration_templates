#!/usr/bin/env bash

# identify port-forward process and kill it if running
PORT_FORWARD_PID=$(pgrep -f "kubectl port-forward deployment/localstack 4566:4566")
if [ -n "$PORT_FORWARD_PID" ]; then
  echo "Killing port-forward process with PID: $PORT_FORWARD_PID"
  kill $PORT_FORWARD_PID
else
  echo "No port-forward process found."
fi

# Stop localstack deployment
kubectl delete deployment localstack

# Stream logs in the background
kubectl logs -l app=localstack -f &
LOG_PID=$!

while kubectl get pods -l app=localstack -o json | jq -e '.items | length > 0' >/dev/null; do
    sleep 1
done

# Pod(s) exited, stop logs
kill $LOG_PID 2>/dev/null

echo "LocalStack deployment deleted."