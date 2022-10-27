#!/bin/bash

if ! docker --help >/dev/null; then
    echo "Needs docker"
    exit 1
fi

if ! jq --help >/dev/null; then
    echo "Needs jq"
    exit 1
fi

export IMAGE_SLUG=raspberry-pi-os-32-bit
export IMAGE_TITLE=Lite
export DOCKER_PI_ARCH=linux/arm/v7

# Latest OS image?
image="$(curl https://downloads.raspberrypi.org/operating-systems-categories.json | jq -c ".[] | select(.slug == \"${IMAGE_SLUG}\") | .images[] | select(.title | contains(\"${IMAGE_TITLE}\"))")"
image_url="$(echo "$image" | jq -rc ".urlHttp")"


# Build
docker buildx build --platform ${DOCKER_PI_ARCH} \
    --build-arg OS_IMAGE_URL="${image_url}" \
    -t "${IMAGE_SLUG}" \
    .

# Start shell
docker run -it --platform="${DOCKER_PI_ARCH}" "${IMAGE_SLUG}" bash
