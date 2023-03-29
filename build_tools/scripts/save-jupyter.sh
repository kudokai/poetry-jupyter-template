#!/bin/bash

set -e

SCRIPT_FILE_PATH=$(realpath $0)
DOCKER_DIR=$(dirname $(dirname $SCRIPT_FILE_PATH))/docker
cd $DOCKER_DIR

docker compose -f poetry-notebook.yml build
docker save jupyter:0.11 | gzip -c  > jupyter_0_11.tar.gz
