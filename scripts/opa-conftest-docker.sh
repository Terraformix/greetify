#!/bin/bash

backend_dockerfile="../greetify-backend/Dockerfile"
#frontend_dockerfile="greetify-frontend/Dockerfile"


files_to_scan=("$backend_dockerfile")

echo $files_to_scan

for file in "${files_to_scan[@]}"; do
    echo "Scanning file: $file"
    docker run --rm -v $(pwd):/rego-policies-opaconftest openpolicyagent/conftest test "$file" --policy rego-policies-opaconftest/opa-docker-security.rego
done