# Raspberry Pi OS

An unofficial Docker image for Raspberry Pi OS lite.

## Tags

Tags mirror the OS release date. New versions are checked daily.

## Caveats

The image is created from the raw system image. You might encounter a few issues, for example:
- It's an ARM7 image - it won't run on AMD64 unless you have qemu-binfmt set up.
- Because it's the unmodified system image some system updates probably won't work.
- Anything reliant on Raspberry Pi hardware obviously will not work.

It's probably fine for testing, I can't imagine a production use case.
