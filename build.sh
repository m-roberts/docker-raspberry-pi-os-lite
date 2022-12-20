#!/bin/bash

if ! docker --help >/dev/null; then
    echo "Needs docker"
    exit 1
fi

if ! jq --help >/dev/null; then
    echo "Needs jq"
    exit 1
fi

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "${DIR}.env"

# Get latest OS image
image="$(curl https://downloads.raspberrypi.org/operating-systems-categories.json | jq -c ".[] | select(.slug == \"${IMAGE_SLUG}\") | .images[] | select(.title | contains(\"${IMAGE_TITLE}\"))")"
image_url="$(echo "$image" | jq -rc ".urlHttp")"

# Build
docker buildx build \
    --platform ${DOCKER_PI_ARCH} \
    --build-arg OS_IMAGE_URL="${image_url}" \
    -t "${IMAGE_SLUG}" \
    .
