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

if command -v docker-compose &> /dev/null ; then
    echo "[skip installation] docker-compose is already installed."
    exit 0
fi

echo "Installing docker-compose"
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "Installed docker-compose successfully."
echo "---------------------------------------------"
docker-compose --version
echo "---------------------------------------------"
