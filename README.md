# podsh
Simple tool to access distroless containers.  

This tools raises a shell to distroless images in order to provide limited shell capabilities into a distroless container. 
This is useful if the kubernetes cluster have no kubectl debug capabilities, or when kubectl debug does not provide proper filesystem access to the main container. 
In the future, when `kubectl cp` does not requires tar executable to be present on the container, it will be helpful in the scenario of having **exec** permisions on distroless containers, allowing to access to the container to pivot or gather information. 

This script just uploads a busybox static binary into the container, installs it and leverages a shell using exec command. It works for both docker and k8s. 

**Usage**
```bash
# k8s
podsh -p podname -n namespace

# docker 
podsh -d container_name

```

NOTE: `kubectl cp` requires `tar` to be available on the running container to copy files to the container. Please, see the Distroless image preparation section. 

## Image preparation
Currently `kubectl cp` requires `tar` binary to be installed on the running container in order to copy files within the containers' file system. 

The open github request with the pertinent discussion:
https://github.com/kubernetes/kubernetes/issues/58512

To prepare a distroless image simply copy the `tar` binary from the base image to the distroless one:
```Dockerfile
# image build
FROM node:16-bullseye-slim AS build

RUN apt-get update -qqq && \
    apt-get upgrade -qqq && \
    apt-get install -y curl

# Downloading the busybox tar binary to embed it on the distroless image. Needed for kubectl cp
RUN mkdir -p /opt/bin && \
    curl -qs https://busybox.net/downloads/binaries/1.35.0-x86_64-linux-musl/busybox_TAR -o /opt/bin/tar && \
    chmod 555 /opt/bin/tar

...

# Distroless stage
FROM gcr.io/distroless/nodejs16-debian11:nonroot
USER nonroot:nonroot
COPY --from=build /opt /

...
```

