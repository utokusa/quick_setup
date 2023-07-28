#!/bin/bash

set -ex

# Install docker, kind, and kubectl

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

# install kubectl

curl -LO https://dl.k8s.io/release/v1.27.4/bin/linux/amd64/kubectl

function clean_up {
    rm kubectl
}
trap clean_up EXIT

$SUDO install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

kubectl version --client

# install docker
# https://docs.docker.com/engine/install/ubuntu/

curl -fsSL https://get.docker.com -o get-docker.sh
$SUDO sh get-docker.sh

# install kind

# For AMD64 / x86_64
[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
# # For ARM64
# [ $(uname -m) = aarch64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-arm64

function clean_up {
    rm kubectl
    rm -f kind
}

chmod +x ./kind
$SUDO mv ./kind /usr/local/bin/kind