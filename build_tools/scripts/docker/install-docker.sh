#! /bin/bash

set -e

# Load env file
SCRIPT_FILE_PATH=$(realpath $0)
SCRIPT_DIR=$(dirname $SCRIPT_FILE_PATH)
ENV_DIR=$(dirname $SCRIPT_DIR)
source $ENV_DIR/env
if [ -z "$COMPOSE_PROJECT_NAME" ]; then
    echo "Failed to load env file."
    exit 1
fi

if command -v docker &> /dev/null ; then
    echo "[skip installation] docker is already installed."
    exit 0
fi 

echo "Installing docker"
sudo apt-get -y update && \
    sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/${DISTRO_NAME}/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/${DISTRO_NAME} \
   $(lsb_release -cs) \
   stable"

sudo apt-get -y update && \
     sudo apt-get install -y \
     docker-ce \
     docker-ce-cli \
     containerd.io

sudo gpasswd -a $USER docker
sudo systemctl restart docker
echo "Installed docker successfully."
echo "---------------------------------------------"
docker --version
echo "---------------------------------------------"
