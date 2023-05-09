FROM docker.io/library/golang:1.20-alpine AS base
ARG HUGO_VERSION=0.111.3

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

RUN mkdir -p "/src/hugo"
WORKDIR "/src/hugo"

RUN apk add --no-cache \
    build-base \
    curl

RUN curl -sSL \
    "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_linux-amd64.tar.gz" -o "hugo_${HUGO_VERSION}_linux-amd64.tar.gz" \
    && HUGO_SHA256="61500f6d39a23d36b946a9f44611c804aec4f1379d6113528672b1ac3077397a" \
    && echo "$HUGO_SHA256  hugo_${HUGO_VERSION}_linux-amd64.tar.gz" \
    | sha256sum -c - \
    && tar -xvf "hugo_${HUGO_VERSION}_linux-amd64.tar.gz"

FROM docker.io/library/golang:1.20-alpine

RUN apk add --no-cache \
    runuser \
    git \
    openssh-client \
    rsync \
    npm && \
    npm install -D tailwindcss postcss autoprefixer

RUN apk update && apk add --no-cache \
    python3 \
    py3-pip \
    && pip install --no-cache-dir svgcheck

RUN mkdir -p /var/hugo && \
    addgroup -Sg 1000 hugo && \
    adduser -Sg hugo -u 1000 -h /var/hugo hugo && \
    chown -R hugo: /var/hugo && \
    runuser -u hugo -- git config --global --add safe.directory /src

COPY --from=base /src/hugo/ /usr/local/bin
RUN chown -R hugo:hugo /usr/local/bin/hugo
WORKDIR /src
USER hugo:hugo
EXPOSE 1313
