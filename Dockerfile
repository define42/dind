FROM docker:24.0.7-dind

RUN apk add fuse-overlayfs
RUN apk add podman
RUN apk add buildah
RUN wget https://raw.githubusercontent.com/containers/libpod/master/contrib/podmanimage/stable/containers.conf -O /etc/containers/containers.conf
