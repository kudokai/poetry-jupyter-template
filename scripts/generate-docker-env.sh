#! /bin/bash

GCP_PROJECT=`gcloud config list --format 'value(core.project)' 2>/dev/null`


set -e

# Load env file
SCRIPT_FILE_PATH=$(realpath $0)
SCRIPT_DIR=$(dirname $SCRIPT_FILE_PATH)
ENV_DIR=$(dirname $SCRIPT_DIR)

cd $SCRIPT_DIR
cd ../
PROJECT_ROOT=$(pwd)

cd ./docker
INSTALL_PATH="$(pwd)"/.env

echo "# docker-compose project name
COMPOSE_PROJECT_NAME=poetry-test

# UID & GID
UID=`id -u`
GID=`id -g`

# GCP
GCP_PROJECT=${GCP_PROJECT}

# Volumes
PATH_TO_PROJECT=${PROJECT_ROOT}
PATH_TO_DATA=${PROJECT_ROOT}/data

# Jupyter
# JUPYTER_PASSWORD=
JUPYTER_PORT=8888
" > ${INSTALL_PATH}
echo "generate ${INSTALL_PATH}"
