#!/bin/bash

if ! docker --help >/dev/null; then
    echo "Needs docker"
    exit 1
fi

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "${DIR}.env"

# Start shell
docker run -it --platform="${DOCKER_PI_ARCH}" "${IMAGE_SLUG}" bash
