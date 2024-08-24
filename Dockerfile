ARG BASE_IMAGE=caddy:2.8.4-builder
FROM ${BASE_IMAGE} AS builder

RUN xcaddy build \
    --with github.com/caddy-dns/azure

ARG FINAL_IMAGE=caddy:2.8.4
FROM ${FINAL_IMAGE}

COPY --from=builder /usr/bin/caddy /usr/bin/caddy