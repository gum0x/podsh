FROM node:16-bullseye-slim AS build

RUN apt-get update -qqq && \
    apt-get upgrade -qqq && \
    apt-get install -y curl

# Downloading the busybox tar binary to embed it on the distroless image. Needed for kubectl cp
RUN mkdir -p /opt/bin && \
    curl -qs https://busybox.net/downloads/binaries/1.35.0-x86_64-linux-musl/busybox_TAR -o /opt/bin/tar && \
    chmod 555 /opt/bin/tar


# Distroless stage
FROM gcr.io/distroless/nodejs16-debian11:nonroot
USER nonroot:nonroot
COPY --from=build /opt /

