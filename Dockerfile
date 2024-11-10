# Use Red Hat UBI 9 as the base image
FROM redhat/ubi9:latest

# Enable the container-tools module and install Podman and required dependencies
RUN dnf -y update && \
    dnf -y install \
        container-tools \
        fuse-overlayfs \
        iptables vim && \
    dnf clean all

RUN dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
RUN dnf install -y docker-compose-plugin

# Configure Podman storage to use fuse-overlayfs, which is suitable for running in a container
RUN mkdir -p /etc/containers && \
    echo -e "[storage]\ndriver = \"overlay\"\n[storage.options.overlay]\nmount_program = \"/usr/bin/fuse-overlayfs\"" > /etc/containers/storage.conf

# Optional: Create a non-root user for Podman operations
RUN useradd -m podmanuser && \
    mkdir -p /home/podmanuser/.config/containers && \
    chown -R podmanuser:podmanuser /home/podmanuser/.config

COPY podman-entrypoint.sh /podman-entrypoint.sh
RUN chmod +x /podman-entrypoint.sh
# Set the default user to avoid running as root (optional)
USER podmanuser
WORKDIR /home/podmanuser
COPY docker-compose.yml /home/podmanuser/test/

ENV XDG_RUNTIME_DIR=/home/podmanuser/podman
RUN mkdir -p /home/podmanuser/podman
RUN chmod 700 /home/podmanuser/podman
ENV PODMAN_API_SOCKET=unix:///home/podmanuser/podman/podman.sock
ENV DOCKER_HOST=unix:///home/podmanuser/podman/podman.sock

ENTRYPOINT ["/podman-entrypoint.sh"]
#ENTRYPOINT ["podman", "system", "service", "--time=0", "unix:/home/podmanuser/podman/podman.sock"]
