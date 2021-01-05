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
image_url="$(echo "$image" | jq -rc ".urlHttp")"
version="$(echo "$image" | jq -rc ".releaseDate")"
re_date='[0-9]{4,}-[0-9]{2,}-[0-9]{2,}'
[[ $image_url =~ $re_date ]]
url_version="$BASH_REMATCH"
# semver style for updaters
semver="${version//-/.}"
semver="${semver//.0/.}"
url_semver="${url_version//-/.}"
url_semver="${url_semver//.0/.}"

# Docker image exists?
if DOCKER_CLI_EXPERIMENTAL=enabled docker manifest inspect "${DOCKER_REPO}:${version}" >/dev/null; then
    echo "Image already exists"
    exit 0
fi

# Build/tag/push
docker build \
    --build-arg OS_IMAGE_URL="$image_url" \
    -t "${DOCKER_REPO}:latest" \
    -t "${DOCKER_REPO}:${semver}" \
    -t "${DOCKER_REPO}:${version}" \
    -t "${DOCKER_REPO}:${url_version}-url" \
    -t "${DOCKER_REPO}:${url_semver}-url" \
    .

docker push "${DOCKER_REPO}:latest"
docker push "${DOCKER_REPO}:${semver}"
docker push "${DOCKER_REPO}:${version}"
docker push "${DOCKER_REPO}:${url_version}-url"
docker push "${DOCKER_REPO}:${url_semver}-url"
