#!/bin/bash

set -ex

GO_VERSION="1.20"
if command -v go &> /dev/null
then
  exit 0
else
  # Install the latest bugfix version of GO_VERSION
  # https://github.com/golang/go/issues/36898 
  install_version=$(curl -sL 'https://go.dev/dl/?mode=json&include=all' | jq -r '.[].version' | grep -m 1 go$GO_VERSION) 
  tar_filename=$install_version.linux-amd64.tar.gz
  curl -sLO "https://go.dev/dl/$tar_filename"
  function clean_up_tar {
      rm "$tar_filename"
  }
  trap clean_up_tar EXIT
  tar -C /usr/local -xzf "$tar_filename"
  echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc && source ~/.bashrc
fi
