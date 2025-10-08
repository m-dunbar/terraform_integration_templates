#!/usr/bin/env bash

# Deploy LocalStack
kubectl apply -f localstack/localstack.deployment.yaml

# Wait for pod Ready condition
kubectl wait --for=condition=ready pod -l app=localstack --timeout=60s

# Start port-forward
kubectl port-forward deployment/localstack 4566:4566 &> /dev/null &
PF_PID=$!

# Wait for LocalStack to report service readiness
until curl -s http://localhost:4566/_localstack/health | grep -q '"s3": "available"'; do
    sleep 0.5
done

echo "LocalStack is ready at http://localhost:4566"