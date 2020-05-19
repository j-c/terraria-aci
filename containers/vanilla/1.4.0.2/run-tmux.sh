#!/bin/bash
set -euo pipefail

# Terraria needs to run in tmux because the Terraria server needs an interactive TTY ("-dit") which is not offered by Azure Container Instance.
echo Running Terraria in tmux...
tmux new-session -d -s terraria_session './run.sh'
tmux list-windows

echo To access the server after attaching to the container, use "tmux attach".
echo To exit from the session, use "<Ctrl+b> d"

# Naive checks once a minuite to tell if the server is still running.
# https://docs.docker.com/config/containers/multi-service_container/
while sleep 60; do
    ps aux | grep TerrariaServer | grep -q -v grep 
    TERRARIA_PROCESS_STATUS=$?
    if [ $TERRARIA_PROCESS_STATUS -ne 0 ]; then
        echo TerrariaServer process not found. Quitting
        exit 1
    fi
done
