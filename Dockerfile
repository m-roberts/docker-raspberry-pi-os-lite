FROM debian:stable-slim AS downloader

RUN apt-get update && apt-get install -y \
    curl \
    libguestfs-tools \
    gzip

ARG OS_IMAGE_URL
RUN curl -L "${OS_IMAGE_URL}" | zcat >/tmp/image && \
    mkdir /pi && \
    echo "copy-out / /pi" | guestfish -a /tmp/image -m /dev/sda2:/ --ro && \
    rm /tmp/image

FROM scratch
COPY --from=downloader /pi /
CMD ["bash"]
