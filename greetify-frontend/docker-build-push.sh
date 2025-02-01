#!/bin/bash

show_usage() {
    echo "Usage: ./docker-build.sh <registry-name> <image-name> <image-tag> [dockerfile-path] [--build-arg KEY=VALUE ...]"
    echo "Example: ./docker-build.sh myregistry.azurecr.io my-image 1.0.0"
}

if [[ "$#" -lt 3 ]]; then
    echo "Error: Insufficient arguments provided."
    show_usage
    exit 1
fi

REGISTRY_NAME="$1"
IMAGE_NAME="$2"
TAG="$3"
DOCKERFILE=${4:-"Dockerfile"}
shift 3

if [[ ! -f "$DOCKERFILE" ]]; then
    echo "Error: Dockerfile not found at path: $DOCKERFILE"
    exit 1
fi

FULL_IMAGE_NAME="$REGISTRY_NAME/$IMAGE_NAME:$TAG"

BUILD_ARGS=()
for arg in "$@"; do
    if [[ "$arg" == --build-arg ]]; then
        if [[ -n "$2" ]]; then
            BUILD_ARGS+=("--build-arg" "$2")
            shift 2
        else
            echo "Error: Missing value for --build-arg."
            exit 1
        fi
    else
        echo "Warning: Ignoring unrecognized argument: $arg"
        shift
    fi
done

echo "🚀 Preparing to build and push Docker image:"
echo "Registry: $REGISTRY_NAME"
echo "Image Name: $IMAGE_NAME"
echo "Tag: $TAG"
echo "Full Image Name: $FULL_IMAGE_NAME"
echo "Dockerfile: $DOCKERFILE"

if [[ "${#BUILD_ARGS[@]}" -gt 0 ]]; then
    echo "Build Args: ${BUILD_ARGS[@]}"
fi

echo "📦 Building Docker image from $DOCKERFILE..."
docker build --no-cache -t "$IMAGE_NAME:$TAG" -f "$DOCKERFILE" . "${BUILD_ARGS[@]}"

docker tag "$IMAGE_NAME:$TAG" "$FULL_IMAGE_NAME"
docker tag "$IMAGE_NAME:$TAG" "$REGISTRY_NAME/$IMAGE_NAME:latest"

echo "⬆️ Pushing Docker image to $REGISTRY_NAME..."
docker push "$FULL_IMAGE_NAME"

echo "✅ Successfully built and pushed $FULL_IMAGE_NAME"
