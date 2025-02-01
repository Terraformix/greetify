#!/bin/bash

ENDPOINT=${1:-'http://localhost/api/greetings'}
TOTAL_REQUESTS=100
V1_COUNT=0
V2_COUNT=0

if [[ -z "$ENDPOINT" ]]; then
  echo "❌ Error: No endpoint provided."
  echo "Usage: bash istio-traffic-split-virtual-service <endpoint>"
  exit 1
fi

for ((i=1; i<=TOTAL_REQUESTS; i++))
do
  # Use External IP of Istio IngressGateway
  # kubectl get svc -n istio-system istio-ingressgateway
  APP_VERSION=$(curl -s -I -X GET $ENDPOINT | grep -i "x-app-version" | awk '{print $2}' | tr -d '\r') # Custom header send from Node.js with the app version to test traffic splitting
  if [[ "$APP_VERSION" == *"v1"* ]]; then
    ((V1_COUNT++))
  elif [[ "$APP_VERSION" == *"v2"* ]]; then
    ((V2_COUNT++))
  fi
done

echo "V1 Requests: $V1_COUNT"
echo "V2 Requests: $V2_COUNT"
