# syntax=docker/dockerfile:1-labs

FROM matefarkas/crystal:1.8.2-alpine AS BUILDER

RUN apk add --no-cache \
    alpine-sdk \
    gc-dev \
    llvm15-dev \
    llvm15-static

# crystal
ARG CRYSTAL_VERSION

WORKDIR /src/crystal

ADD --keep-git-dir=true https://github.com/crystal-lang/crystal.git#${CRYSTAL_VERSION} .

RUN make release=1 static=1

# shards
ARG SHARDS_VERSION

WORKDIR /src/shards

ADD --keep-git-dir=true https://github.com/crystal-lang/shards.git#v${SHARDS_VERSION} .

RUN make bin/shards release=1 static=1

###################################
FROM alpine:3.17.1 AS ALPINE-RUNNER

COPY --from=BUILDER /src/crystal/src/ /usr/share/crystal/src
COPY --from=BUILDER /src/crystal/.build/crystal /usr/bin/crystal
COPY --from=BUILDER /src/shards/bin/shards /usr/bin/shards

RUN apk add --no-cache \
    gc-dev \
    gcc \
    git \
    gmp-dev \
    libevent-static \
    libxml2-dev \
    libxml2-static \
    make \
    musl-dev \
    openssl-dev \
    openssl-libs-static \
    pcre-dev \
    pcre2-dev \
    tzdata \
    xz-static \
    yaml-static \
    zlib-static

ENTRYPOINT ["/usr/bin/crystal"]

##################################
FROM ubuntu:22.04 AS UBUNTU-RUNNER

COPY --from=BUILDER /src/crystal/src/ /usr/share/crystal/src
COPY --from=BUILDER /src/crystal/.build/crystal /usr/bin/crystal
COPY --from=BUILDER /src/shards/bin/shards /usr/bin/shards

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    gcc \
    git \
    libevent-dev \
    libgc-dev \
    libgmp-dev \
    libpcre2-dev \
    libpcre3-dev \
    libssl-dev \
    libxml2-dev \
    libyaml-dev \
    make \
    pkg-config \
    tzdata \
    zlib1g-dev \
  && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/usr/bin/crystal"]
