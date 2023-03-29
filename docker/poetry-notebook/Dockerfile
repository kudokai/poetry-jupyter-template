FROM python:3.9-slim

ENV USER="jovyan" \
    UID="1000" \
    GID="100"
ENV HOME=/home/$USER
ENV SHELL=/bin/bash
USER root

RUN apt-get update \
    && apt-get install -yq --no-install-recommends \
    curl \
    sudo \
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
COPY $CONTEXT_DIR/install-poetry.py $HOME/install-poetry.py
ARG POETRY_VERSION=1.3.2
ENV POETRY_VERSION=$POETRY_VERSION
ENV POETRY_HOME=/opt/poetry
RUN python3 $HOME/install-poetry.py
ENV PATH=$POETRY_HOME/bin:$PATH
RUN mkdir -p $HOME/.cache/pypoetry \
    && fix-permissions $HOME/.cache/pypoetry

## Copy scripts and fix permissions
COPY $CONTEXT_DIR/start.sh /usr/local/bin/start.sh
COPY $CONTEXT_DIR/poetry-setup.sh /usr/local/bin/poetry-setup.sh
COPY $CONTEXT_DIR/jupyter_notebook_config.py $HOME/.jupyter/jupyter_notebook_config.py
COPY $CONTEXT_DIR/start-python-proc.sh /usr/local/bin/start-python-proc.sh
RUN chmod a+rx /usr/local/bin/start.sh \
    && chmod a+rx /usr/local/bin/poetry-setup.sh \
    && chmod a+rx /usr/local/bin/start-python-proc.sh \
    # && fix-permissions $HOME/.jupyter/jupyter_notebook_config.py \
    && mkdir $HOME/.jupyter/lab \
    # && fix-permissions $HOME/.jupyter/lab
    && fix-permissions $HOME/.jupyter

WORKDIR $HOME/work
ENV PYTHONPATH=$PYTHONPATH:$HOME/work/src
ENTRYPOINT [ "start.sh" ]
