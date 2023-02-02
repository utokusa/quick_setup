#!/bin/bash

# Usage: './sshd_setup.sh <ssh public key>'

SUDO=""
if [ "$EUID" != 0 ]; then
  SUDO="sudo"
fi

if [ "$1" == "" ]; then
  echo "Provide ssh public key as argument"
  exit 1
fi

$SUDO apt install -y openssh-server

SSH_PUB_KEY=$1
mkdir -p $HOME/.ssh
echo "$SSH_PUB_KEY" >> $HOME/.ssh/authorized_keys

$SUDO service ssh restart

echo "Make sure 'PubkeyAuthentication yes' is set in /etc/ssh/sshd_config"

