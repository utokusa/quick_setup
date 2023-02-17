#!/bin/bash

set -ex

function usage {
    echo "Usage: ./quick_setup.sh [-e | --email <email address>] [-u | --username <username>] [-g | --github-cli] [-f | --full-install]"
}

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    -e|--email)
      EMAIL="$2"
      shift # past argument
      shift # past value
      ;;
    -u|--username)
      USERNAME="$2"
      shift # past argument
      shift # past value
      ;;
    -g|--github-cli)
      # include interactive steps
      SETUP_GITHUB_CLI=YES
      shift # past argument
      ;;
    -f|--full-install)
      FULL_INSTALL=YES
      shift # past argument
      ;;
    -h|--help)
	  usage
      exit 0 
      ;;
    -*|--*)
      echo "Unknown option $2"
	  usage
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift # past argument
      ;;
  esac
done

# ---- Handle sudo
SUDO=""
if [ "$EUID" != 0 ]; then
	SUDO="sudo"
fi

# ---- Minimum setup
$SUDO apt update
$SUDO apt install -y git vim tmux curl

cp ./configs/.tmux.conf ~/
cp ./configs/.vimrc ~/

# git config
# You can check the result with `git config --list`
if [ "$USERNAME" != "" ]; then
  git config --global user.name "$USERNAME"
fi 
if [ "$EMAIL" != "" ]; then
  git config --global user.email "$EMAIL"
fi 
git config --global core.editor vim

# ---- Full install
if [ "$FULL_INSTALL" == "YES" ]; then
  echo "Full install..."
  if command -v unminimize &> /dev/null; then
    yes | $SUDO unminimize
  fi
  $SUDO apt install -y wget jq
  $SUDO apt install -y lsof net-tools
  # Install tzdata without prompt (It's a mand-db's dependency)
  # https://stackoverflow.com/questions/44331836/apt-get-install-tzdata-noninteractive
  $SUDO apt-get update
  DEBIAN_FRONTEND=noninteractive $SUDO apt-get install -y tzdata

  $SUDO apt install -y man-db manpages-dev manpages-posix-dev

  # Neovim
  # https://github.com/neovim/neovim/wiki/Installing-Neovim#ubuntu
  $SUDO apt-get install -y software-properties-common
  $SUDO add-apt-repository -y ppa:neovim-ppa/unstable
  $SUDO apt-get update
  $SUDO apt-get install -y neovim
  mkdir -p ~/.config/nvim
  cp configs/.config/nvim/init.lua ~/.config/nvim/
  # For LSP
  $SUDO apt install -y luajit clang clangd
fi

# ---- Setup including interactive steps
if [ "$SETUP_GITHUB_CLI" == "YES" ] || [ "$FULL_INSTALL" == "YES" ]; then
  echo "Setting up GitHub CLI..."
  type -p curl >/dev/null || $SUDO apt install curl -y
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | $SUDO dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
  && $SUDO chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | $SUDO tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
  && $SUDO apt update \
  && $SUDO apt install gh -y
  gh auth login
fi
