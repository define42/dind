FROM docker:24.0.7-dind

RUN apk add fuse-overlayfs
RUN apk add podman
RUN apk add buildah
