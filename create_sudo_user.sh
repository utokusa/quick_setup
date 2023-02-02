#!/bin/bash

if [ "$EUID" != 0 ]; then
  echo "This script needs to be run as root"
  exit 1
fi

if [ "$1" == "" ]; then
  echo "Provide user name as argument"
  exit 1
fi

USERNAME=$1

apt update
apt install sudo

useradd -m $USERNAME
echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
echo "User '$USERNAME' was added"

