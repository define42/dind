#!/bin/bash
set -e

if [ -f "${CA_CERTIFICATES_PATH}" ]; then
  echo "Custom CA certificate found at ${CA_CERTIFICATES_PATH}."
  echo "Copying certificate to /etc/pki/ca-trust/source/anchors/..."
  cp "${CA_CERTIFICATES_PATH}" /etc/pki/ca-trust/source/anchors/
  
  echo "Updating the CA trust store..."
  update-ca-trust
  echo "CA trust store updated successfully."
else
  echo "No custom CA certificate found at ${CA_CERTIFICATES_PATH}."
fi

# Execute CMD
#/usr/bin/podman system service --time=0 unix:/home/podmanuser/podman/podman.sock
exec "$@"
