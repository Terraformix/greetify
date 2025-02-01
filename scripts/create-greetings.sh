#!/bin/bash

ENDPOINT="https://greetify.site/api/greetings"
#ENDPOINT="http://localhost/api/greetings"

NUM_REQUESTS=${1:-100}
GREETING="Hello"

generate_random_identifier() {
  local length=${1:-3} # Default length is 8 if not provided
  local charset="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  local identifier=""
  for ((i=1; i<=length; i++)); do
    identifier+="${charset:RANDOM%${#charset}:1}"
  done
  echo "$identifier"
}

echo "🚀 Sending $NUM_REQUESTS requests to $ENDPOINT..."

for ((i=1; i <= NUM_REQUESTS; i++)); do
  LANGUAGE="lang$(generate_random_identifier)"
  PAYLOAD="{\"language\": \"$LANGUAGE\", \"greeting\": \"$GREETING\", \"skipValidityCheck\": true}"
  curl -s -X POST -H "Content-Type: application/json" -d "$PAYLOAD" "$ENDPOINT"
  echo "✨ Sent request #$i: $PAYLOAD 🌈"
done

echo "🎉 All $NUM_REQUESTS requests sent!"