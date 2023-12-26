#!/bin/bash

set -e

SCRIPT_FILE_PATH=$(realpath $0)
DOCKER_DIR=$(dirname $(dirname $SCRIPT_FILE_PATH))/docker
cd $DOCKER_DIR

docker compose -f docker-compose.yml down --rmi all
