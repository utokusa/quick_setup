#!/bin/bash

set -ex

# Install sonobuoy

# ---- Handle sudo
SUDO=""
if [ "$EUID" != 0 ]; then
    SUDO="sudo"
fi

# install curl

if ! command -v curl &> /dev/null
then
    $SUDO apt update && $SUDO apt install -y curl
fi

# install sonobuoy
# https://sonobuoy.io/docs/main/

SONOBUOY_VERSION="0.56.16"
SONOBUOY_TAR_FILE_NAME="sonobuoy_${SONOBUOY_VERSION}_linux_amd64.tar.gz"

curl -sLO "https://github.com/vmware-tanzu/sonobuoy/releases/download/v$SONOBUOY_VERSION/$SONOBUOY_TAR_FILE_NAME"
function clean_up {
    rm $SONOBUOY_TAR_FILE_NAME
    rm LICENSE # from sonobuoy
}
trap clean_up EXIT

tar -xvf $SONOBUOY_TAR_FILE_NAME
$SUDO mv sonobuoy /usr/local/bin
