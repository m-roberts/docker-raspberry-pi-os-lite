# Raspberry Pi OS

An unofficial Docker image for Raspberry Pi OS lite.

Modified from `jonohill/docker-raspberry-pi-os`:
* No longer pushes to Docker Hub
* Updated to handle RPi OS's `.img.xz` format (instead of `.zip`)

## Caveats

The image is created from the raw system image. You might encounter a few issues:

- ARM7 image
- Unmodified, unbooted system image
- Unable to do anything intended for hardware

👌 Testing
☠️ Production
