#!/usr/bin/env bash
set -euo pipefail

# Example usage:
# export DOCKERHUB_USER=yourdockerhubuser
# export IMAGE_NAME=devops-miniapp
# export TAG=v1
# ./project2-docker-ec2/scripts/build_and_push.sh
# or pass as args:
# ./project2-docker-ec2/scripts/build_and_push.sh yourdockerhubuser devops-miniapp v1
DOCKERHUB_USER="${1:-${DOCKERHUB_USER:-}}"
IMAGE_NAME="${2:-${IMAGE_NAME:-devops-miniapp}}"
TAG="${3:-${TAG:-latest}}"

if [[ -z "$DOCKERHUB_USER" ]]; then
	echo "Usage: $0 <dockerhub-user> [image-name] [tag]"
	echo "Or set DOCKERHUB_USER as an environment variable."
	exit 1
fi

FULL_IMAGE="$DOCKERHUB_USER/$IMAGE_NAME:$TAG"

# Build image from repository root context so Dockerfile can copy sample-python-app/.
docker build -f project2-docker-ec2/Dockerfile -t "$FULL_IMAGE" .

echo "Built image: $FULL_IMAGE"
echo "Pushing image to Docker Hub..."
docker push "$FULL_IMAGE"

echo "Done. Remote server can now pull: $FULL_IMAGE"
