#!/bin/bash

set -ex

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

# install kubeadm
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

$SUDO apt-get update
$SUDO apt-get install -y apt-transport-https ca-certificates gpg

$SUDO mkdir -p /etc/apt/keyrings
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | $SUDO gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | $SUDO tee /etc/apt/sources.list.d/kubernetes.list

$SUDO apt-get update
$SUDO apt-get install -y kubelet kubeadm kubectl
$SUDO apt-mark hold kubelet kubeadm kubectl

