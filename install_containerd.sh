#!/bin/bash

set -ex

# install curl

if ! command -v curl &> /dev/null
then
    apt update && apt install -y curl
fi

# install containerd
# https://github.com/containerd/containerd/blob/main/docs/getting-started.md

VERSION=1.7.2
TAR_FILE_NAME="containerd-$VERSION-linux-amd64.tar.gz"
curl -sLO "https://github.com/containerd/containerd/releases/download/v$VERSION/$TAR_FILE_NAME"

function clean_up_tar {
    rm "$TAR_FILE_NAME"
}
trap clean_up_tar EXIT

tar Cxzvf "/usr/local" $TAR_FILE_NAME

# setup for systemd
curl --create-dirs --output /usr/local/lib/systemd/system/containerd.service "https://raw.githubusercontent.com/containerd/containerd/main/containerd.service"

# install runc

curl -sLO "https://github.com/opencontainers/runc/releases/download/v1.1.7/runc.amd64"
function clean_up_tar {
    rm "$TAR_FILE_NAME"
    rm runc.amd64
}
install -m 755 runc.amd64 /usr/local/sbin/runc

# install CNI plugins
CNI_VERSION=1.3.0
CNI_TAR_FILE_NAME="cni-plugins-linux-amd64-v$CNI_VERSION.tgz"
curl -sLO "https://github.com/containernetworking/plugins/releases/download/v$CNI_VERSION/$CNI_TAR_FILE_NAME"
function clean_up_tar {
    rm "$TAR_FILE_NAME"
    rm runc.amd64
    rm $CNI_TAR_FILE_NAME
}
mkdir -p /opt/cni/bin
tar Cxzvf "/opt/cni/bin" $CNI_TAR_FILE_NAME

# [optional] install sonobuoy
# https://sonobuoy.io/docs/main/

SONOBUOY_VERSION="0.56.16"
SONOBUOY_TAR_FILE_NAME="sonobuoy_${SONOBUOY_VERSION}_linux_amd64.tar.gz"

curl -sLO "https://github.com/vmware-tanzu/sonobuoy/releases/download/v$SONOBUOY_VERSION/$SONOBUOY_TAR_FILE_NAME"
function clean_up_tar {
    rm "$TAR_FILE_NAME"
    rm runc.amd64
    rm $CNI_TAR_FILE_NAME
    rm $SONOBUOY_TAR_FILE_NAME
    rm LICENSE # from sonobuoy
}

tar -xvf $SONOBUOY_TAR_FILE_NAME
mv sonobuoy /usr/local/bin
