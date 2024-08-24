# syntax=docker/dockerfile:1.3
ARG BASE_IMAGE
ENV BASE_IMAGE ${BASE_IMAGE}
FROM ${BASE_IMAGE} AS builder

RUN xcaddy build \
    --with github.com/caddy-dns/azure

ARG FINAL_IMAGE
ENV FINAL_IMAGE ${FINAL_IMAGE}
FROM ${FINAL_IMAGE}

COPY --from=builder /usr/bin/caddy /usr/bin/caddy