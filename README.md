# Docker containers for `aarch64` Linux Crystal compilers

## Build

```bash
docker compose build crystal-alpine
docker compose build crystal-ubuntu
```

## Bootstrap

Build initial `aarch64` image by cross-compiling on the official `amd64` image.

```bash
docker compose build crystal-alpine-bootstrap
```
