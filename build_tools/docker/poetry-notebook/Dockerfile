FROM python:3.8-slim-buster

ENV USER="jovyan" \
    UID="1000" \
    GID="1001"
ENV HOME=/home/$USER
ENV SHELL=/bin/bash
ENV DEB_PYTHON_INSTALL_LAYOUT=deb
USER root

RUN apt-get update \
    && apt-get install -yq --no-install-recommends \
    curl \
    sudo \
    git \
    gcc \
    g++ \
    libc6-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Make home directory and fix permissions
ARG CONTEXT_DIR
COPY $CONTEXT_DIR/fix-permissions /usr/local/bin/fix-permissions
RUN chmod a+rx /usr/local/bin/fix-permissions \
    && useradd -s /bin/bash -N -u $UID $USER \
    && mkdir $HOME \
    && fix-permissions $HOME

# Install Poetry
ARG POETRY_VERSION
ENV POETRY_VERSION=$POETRY_VERSION
ENV POETRY_VIRTUALENVS_PATH=$HOME/.local
ENV POETRY_HOME=$HOME/.poetry
ENV PATH=$POETRY_HOME/bin/:$PATH
RUN mkdir $HOME/.local \
    && fix-permissions $HOME/.local \
    && curl -sSL https://install.python-poetry.org | python3 - \
    && fix-permissions $HOME/.poetry

## Copy scripts and fix permissions
COPY $CONTEXT_DIR/start.sh /usr/local/bin/start.sh
COPY $CONTEXT_DIR/poetry-setup.sh /usr/local/bin/poetry-setup.sh
COPY $CONTEXT_DIR/jupyter_lab_config.py $HOME/.jupyter/jupyter_lab_config.py
COPY $CONTEXT_DIR/start-python-proc.sh /usr/local/bin/start-python-proc.sh
RUN chmod a+rx /usr/local/bin/start.sh \
    && chmod a+rx /usr/local/bin/poetry-setup.sh \
    && chmod a+rx /usr/local/bin/start-python-proc.sh \
    && mkdir $HOME/.jupyter/lab \
    && fix-permissions $HOME/.jupyter

WORKDIR $HOME/work
ENV PYTHONPATH=$PYTHONPATH:$HOME/work/src

COPY pyproject.toml poetry.lock ./
ENV POETRY_VIRTUALENVS_CREATE=false
RUN poetry run pip install --upgrade pip setuptools \
    && poetry install --no-root \
    && rm pyproject.toml poetry.lock \
    && fix-permissions $HOME/.cache 

ENTRYPOINT [ "start.sh" ]
