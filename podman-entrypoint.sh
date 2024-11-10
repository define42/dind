#!/bin/bash
set -e

# Execute CMD
#/usr/bin/podman system service --time=0 unix:/home/podmanuser/podman/podman.sock
exec "$@"
