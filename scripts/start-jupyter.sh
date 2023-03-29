#!/bin/bash

set -e

SCRIPT_FILE_PATH=$(realpath $0)
DOCKER_DIR=$(dirname $(dirname $SCRIPT_FILE_PATH))/docker
cd $DOCKER_DIR

docker compose -f docker-compose.yml build
docker compose -f docker-compose.yml up -d
docker compose logs -f