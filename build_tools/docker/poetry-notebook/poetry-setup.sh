#!/usr/bin/env bash

set -e

POETRY_DIR="$HOME/work/"
POETRY_PROJECT_FILE="pyproject.toml"

if [ -f "${POETRY_DIR}/${POETRY_PROJECT_FILE}" ]; then
    echo "[poetry] pyproject.toml is detected. Installing dependencies..."
    echo "Install skipped."
    cd $POETRY_DIR
    # poetry run pip install --upgrade pip
    # poetry install
fi
