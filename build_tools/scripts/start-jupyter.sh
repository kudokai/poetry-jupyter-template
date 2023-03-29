#!/bin/bash

set -e

SCRIPT_FILE_PATH=$(realpath $0)
DOCKER_DIR=$(dirname $(dirname $SCRIPT_FILE_PATH))/docker
cd $DOCKER_DIR

docker load < ./jupyter_0_11.tar.gz
docker compose -f poetry-notebook.yml up --no-build -d
