#!/bin/bash
# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

set -e

# Exec the specified command or fall back on bash
if [ $# -eq 0 ]; then
    cmd=( "start-python-proc.sh" )
else
    cmd=( "$@" )
fi

run-hooks () {
    # Source scripts or run executable files in a directory
    if [[ ! -d "$1" ]] ; then
        return
    fi
    echo "$0: running hooks in $1"
    for f in "$1/"*; do
        case "$f" in
            *.sh)
                echo "$0: running $f"
                source "$f"
                ;;
            *)
                if [[ -x "$f" ]] ; then
                    echo "$0: running $f"
                    "$f"
                else
                    echo "$0: ignoring $f"
                fi
                ;;
        esac
    done
    echo "$0: done running hooks in $1"
}

run-hooks /usr/local/bin/start-notebook.d

# Handle special flags if we're root
if [ $(id -u) == 0 ] ; then

    # Only attempt to change the jovyan username if it exists
    if id jovyan &> /dev/null ; then
        echo "Set username to: $USER"
        usermod -d /home/$USER -l $USER jovyan
    fi

    # Handle case where provisioned storage does not have the correct permissions by default
    # Ex: default NFS/EFS (no auto-uid/gid)
    if [[ "$CHOWN_HOME" == "1" || "$CHOWN_HOME" == 'yes' ]]; then
        echo "Changing ownership of /home/$USER to $UID:$GID with options '${CHOWN_HOME_OPTS}'"
        chown $CHOWN_HOME_OPTS $UID:$GID /home/$USER
    fi
    if [ ! -z "$CHOWN_EXTRA" ]; then
        for extra_dir in $(echo $CHOWN_EXTRA | tr ',' ' '); do
            echo "Changing ownership of ${extra_dir} to $UID:$GID with options '${CHOWN_EXTRA_OPTS}'"
            chown $CHOWN_EXTRA_OPTS $UID:$GID $extra_dir
        done
    fi

    # handle home and working directory if the username changed
    if [[ "$USER" != "jovyan" ]]; then
        # changing username, make sure homedir exists
        # (it could be mounted, and we shouldn't create it if it already exists)
        if [[ ! -e "/home/$USER" ]]; then
            echo "Relocating home dir to /home/$USER"
            mv /home/jovyan "/home/$USER" || ln -s /home/jovyan "/home/$USER"
        fi
        # if workdir is in /home/jovyan, cd to /home/$USER
        if [[ "$PWD/" == "/home/jovyan/"* ]]; then
            newcwd="/home/$USER/${PWD:13}"
            echo "Setting CWD to $newcwd"
            cd "$newcwd"
        fi
    fi

    # Change UID:GID of USER to UID:GID if it does not match
    if [ "$UID" != $(id -u $USER) ] || [ "$GID" != $(id -g $USER) ]; then
        echo "Set user $USER UID:GID to: $UID:$GID"
        if [ "$GID" != $(id -g $USER) ]; then
            groupadd -g $GID -o ${GROUP:-${USER}}
        fi
        userdel $USER
        useradd --home /home/$USER -u $UID -g $GID -G 100 -l $USER
    fi

    # Enable sudo if requested
    if [[ "$GRANT_SUDO" == "1" || "$GRANT_SUDO" == 'yes' ]]; then
        echo "Granting $USER sudo access and appending $CONDA_DIR/bin to sudo PATH"
        echo "$USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/notebook
    fi

    # Exec the command as USER with the PATH and the rest of
    # the environment preserved
    run-hooks /usr/local/bin/before-notebook.d
    if [ -e $HOME/.local ]; then
        chown -R jovyan $HOME/.local
    fi
    if [[ "$ENV" == "BASE" ]]; then
        sudo -E -H -u $USER PATH=$PATH XDG_CACHE_HOME=/home/$USER/.cache PYTHONPATH=${PYTHONPATH:-} "poetry-setup.sh"
    elif [[ "$ENV" == "DEV" ]]; then
        chown -R jovyan /var/run/docker.sock
        sudo -E -H -u $USER PATH=$PATH XDG_CACHE_HOME=/home/$USER/.cache PYTHONPATH=${PYTHONPATH:-} "poetry-setup.sh"
    elif [[ "$ENV" == "PROD" ]]; then
        chown -R jovyan $HOME/work
    fi
    echo "Executing the command: ${cmd[@]}"
    exec sudo -E -H -u $USER PATH=$PATH XDG_CACHE_HOME=/home/$USER/.cache PYTHONPATH=${PYTHONPATH:-} "${cmd[@]}"
else
    if [[ "$UID" == "$(id -u jovyan)" && "$GID" == "$(id -g jovyan)" ]]; then
        # User is not attempting to override user/group via environment
        # variables, but they could still have overridden the uid/gid that
        # container runs as. Check that the user has an entry in the passwd
        # file and if not add an entry.
        STATUS=0 && whoami &> /dev/null || STATUS=$? && true
        if [[ "$STATUS" != "0" ]]; then
            if [[ -w /etc/passwd ]]; then
                echo "Adding passwd file entry for $(id -u)"
                cat /etc/passwd | sed -e "s/^jovyan:/nayvoj:/" > /tmp/passwd
                echo "jovyan:x:$(id -u):$(id -g):,,,:/home/jovyan:/bin/bash" >> /tmp/passwd
                cat /tmp/passwd > /etc/passwd
                rm /tmp/passwd
            else
                echo 'Container must be run with group "root" to update passwd file'
            fi
        fi

        # Warn if the user isn't going to be able to write files to $HOME.
        if [[ ! -w /home/jovyan ]]; then
            echo 'Container must be run with group "users" to update files'
        fi
    else
        # Warn if looks like user want to override uid/gid but hasn't
        # run the container as root.
        if [[ ! -z "$UID" && "$UID" != "$(id -u)" ]]; then
            echo 'Container must be run as root to set $UID'
        fi
        if [[ ! -z "$GID" && "$GID" != "$(id -g)" ]]; then
            echo 'Container must be run as root to set $GID'
        fi
    fi

    # Warn if looks like user want to run in sudo mode but hasn't run
    # the container as root.
    if [[ "$GRANT_SUDO" == "1" || "$GRANT_SUDO" == 'yes' ]]; then
        echo 'Container must be run as root to grant sudo permissions'
    fi

    # Execute the command
    run-hooks /usr/local/bin/before-notebook.d
    echo "Executing the command: ${cmd[@]}"
    exec "${cmd[@]}"
fi
