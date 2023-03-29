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

cd $SCRIPT_DIR
cd ../../../
PROJECT_ROOT=$(pwd)

cd ./build_tools/docker
INSTALL_PATH="$(pwd)"/.env

echo "# docker-compose project name
COMPOSE_PROJECT_NAME=${COMPOSE_PROJECT_NAME}

# UID & GID
UID=`id -u`
GID=`id -g`

# Volumes
PATH_TO_PROJECT=${PROJECT_ROOT}
PATH_TO_DATA=${PROJECT_ROOT}/data

# Jupyter
JUPYTER_PASSWORD=${JUPYTER_PASSWORD}
JUPYTER_PORT=${JUPYTER_PORT}

# Streamlit
STREAMLIT_PORT=${STREAMLIT_PORT}
RUN_STREAMLIT=${RUN_STREAMLIT}
STREAMLIT_APP_NAME=${STREAMLIT_APP_NAME}

# Dashboard
DASHBOARD_PORT=${DASHBOARD_PORT}
DASHBOARD_PORT_2=${DASHBOARD_PORT_2}
RUN_DASHBOARD=${RUN_DASHBOARD}
DASHBOARD_CONFIG_NAME=${DASHBOARD_CONFIG_NAME}

# Poetry
POETRY_VERSION=${POETRY_VERSION}
" > ${INSTALL_PATH}
echo "generate ${INSTALL_PATH}"
