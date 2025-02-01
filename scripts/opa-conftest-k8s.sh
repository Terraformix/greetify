#!/bin/bash

# 🚀 Kubernetes Manifest Scanner 🚀

# Ensure the correct number of arguments is provided
if [ "$#" -lt 1 ]; then
  echo "⚠️  Usage: $0 <ENVIRONMENT>"
  echo "Example: $0 DEV or $0 PROD"
  exit 1
fi

# Define environment variable
ENV=$1

# Validate the environment argument
if [[ "$ENV" != "DEV" && "$ENV" != "PROD" ]]; then
  echo "❌ Error: You must pass 'DEV' or 'PROD' as the first argument."
  exit 1
fi

# Kubernetes manifest files to scan
files_to_scan=(
  "backend-deployment.yaml"
  "frontend-deployment.yaml"
  "db-deployment.yaml"
])

# Helm release name
helm_release_name="greetify-${ENV}"

echo "🌍 Performing OPA Conftest scan - Static security analysis for Kubernetes manifests on ${ENV}"
echo "📄 Number of files to scan: ${#files_to_scan[@]}"
echo "**************************************************"

# Loop through the files to scan
for file in "${files_to_scan[@]}"; do
  echo "🔍 Processing: $file"

  # Render the Helm template
  helm_output=$(helm template "greetify" "./helm/$helm_release_name/" --show-only "templates/$file" 2>&1)
  
  # Check if Helm template rendering was successful
  if [[ $? -ne 0 ]]; then
    echo "❌ Error: Failed to render the Helm manifest for $file."
    echo "💬 Helm Output: $helm_output"
    exit 1
  fi

  # Create a temporary file for the rendered output
  temp_file=$(mktemp "${file%.yaml}-rendered-XXXX.yaml")
  echo "$helm_output" > "$temp_file"

  # Perform the Conftest scan
  docker run --rm -v $(pwd):/project openpolicyagent/conftest test "/project/$temp_file" --policy rego-policies-opaconftest/opa-k8s-security.rego
  
  # Check if the scan was successful
  if [[ $? -ne 0 ]]; then
    echo "❌ Security scan failed for $file."
    echo "🗑️  Removing temporary file: $temp_file"
    rm -f "$temp_file"
    exit 1
  fi

  echo "✅ Scan passed for $file."
  echo "🗑️  Removing temporary file: $temp_file"
  rm -f "$temp_file"
  echo "**************************************************"
done

echo "🎉 All files scanned successfully! No issues found."
