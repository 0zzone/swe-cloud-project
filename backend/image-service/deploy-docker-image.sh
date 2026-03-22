#!/bin/bash

# Variables
IMAGE_NAME="matt91320/image-service"
TAG="latest"

PLATFORM="linux/amd64,linux/arm64"

echo "📦 Plateforme : $PLATFORM"

# ── Build & Push ──────────────────────────────────────────────────────────────
echo "Building Docker image..."
docker buildx build --platform "$PLATFORM" -t $IMAGE_NAME:$TAG --push .

echo "Docker image pushed successfully: $IMAGE_NAME:$TAG"