#!/bin/bash

set -e

SCRIPT_FILE_PATH=$(realpath $0)
SCRIPT_DIR=$(dirname $SCRIPT_FILE_PATH)
BASH_PATH="/bin/bash"

${BASH_PATH} -c "${SCRIPT_DIR}/docker/install-docker.sh"
${BASH_PATH} -c "${SCRIPT_DIR}/docker/install-docker-compose.sh"
${BASH_PATH} -c "${SCRIPT_DIR}/docker/generate-docker-env.sh"

# Make data dir if does not exist
SCRIPT_FILE_PATH=$(realpath $0)
SCRIPT_DIR=$(dirname $SCRIPT_FILE_PATH)
cd $SCRIPT_DIR
cd ../../
PROJECT_ROOT=$(pwd)
DATA_DIR=$PROJECT_ROOT/data/
mkdir -p $DATA_DIR
