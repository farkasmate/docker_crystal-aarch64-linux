# Docker containers for `aarch64` Linux Crystal compilers

## Build

```bash
docker compose build crystal-alpine
docker compose build crystal-ubuntu
```

## Bootstrap

Build initial `aarch64` image by cross-compiling on the official `amd64` image.

```bash
docker run --rm --privileged aptman/qus:latest -s -- -p x86_64
docker compose build crystal-alpine-bootstrap
```
