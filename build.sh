#!/bin/bash

if ! docker --help >/dev/null; then
    echo "Needs docker"
    exit 1
fi

if ! jq --help >/dev/null; then
    echo "Needs jq"
    exit 1
fi

export DOCKER_REPO=jonoh/raspberry-pi-os
export IMAGE_SLUG=raspberry-pi-os-32-bit
export IMAGE_TITLE=Lite

# Latest OS image?
image="$(curl https://downloads.raspberrypi.org/operating-systems-categories.json | jq -c ".[] | select(.slug == \"${IMAGE_SLUG}\") | .images[] | select(.title | contains(\"${IMAGE_TITLE}\"))")"
version="$(echo "$image" | jq -rc ".releaseDate")"
# semver style for updaters
semver="${version//-/.}"
semver="${semver//.0/.}"
url="$(echo "$image" | jq -rc ".urlHttp")"

# Docker image exists?
if DOCKER_CLI_EXPERIMENTAL=enabled docker manifest inspect "${DOCKER_REPO}:${version}" >/dev/null; then
    echo "Image already exists"
    exit 0
fi

# Build/tag/push
docker build --build-arg OS_IMAGE_URL="$url" -t "${DOCKER_REPO}:${semver}" -t "${DOCKER_REPO}:${version}" .
docker push "${DOCKER_REPO}:${semver}"
docker push "${DOCKER_REPO}:${version}"
