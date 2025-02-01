#!/bin/bash

# 🚀 Trivy Image Scanner 🚀
# Scans specified Docker images for vulnerabilities.

# Collect all image names passed as arguments
images=("node:20.18-alpine3.20" "node:lts-alpine" "nginx:stable-alpine")

echo "🌍 Performing Trivy scan on Docker images..."
echo "**************************************************"

for image in "${images[@]}"; do
  echo "🔍 Scanning image: $image"

  docker run --rm -v "$(pwd):/root/.cache/" aquasec/trivy -q image --exit-code 1 --severity HIGH,CRITICAL --light "$image"

  exit_code=$?

  if [[ "$exit_code" -eq 1 ]]; then
    echo "❌ Scan failed for $image. HIGH or CRITICAL vulnerabilities found."
  elif [[ "$exit_code" -eq 0 ]]; then
    echo "✅ Scan passed for $image. No HIGH or CRITICAL vulnerabilities found."
  else
    echo "⚠️ Unexpected exit code ($exit_code) from Trivy scan for $image."
  fi

  echo "**************************************************"
done

echo "🎉 All images scanned successfully!"
