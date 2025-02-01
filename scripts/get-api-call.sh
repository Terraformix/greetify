#!/bin/bash

# Check if wrk is installed
if ! command -v wrk &> /dev/null
then
    echo "'wrk' could not be found. Installing wrk..."
    sudo apt-get install -y wrk || echo "❌ Error: 'wrk' is not available in apt-get. Install manually."
    exit 1
fi


ENDPOINT=$1
THREADS=50  # Reduced for better stability
CONCURRENCY=300
DURATION="260"

if [[ -z "$ENDPOINT" ]]; then
  echo "❌ Error: No endpoint provided."
  echo "Usage: bash get-api-call <endpoint>"
  exit 1
fi

echo "🚀 Stress testing $ENDPOINT with $CONCURRENCY concurrency for $DURATION seconds using $THREADS threads..."
wrk -t$THREADS -c$CONCURRENCY -d$DURATION $ENDPOINT
echo "🎉 Completed the stress test on $ENDPOINT"
