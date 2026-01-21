#!/usr/bin/env bash
# ~/lab/labs/pilot-shell.sh

PROJECT="alpha"

if podman ps --format '{{.Names}}' | grep -q "lab-$PROJECT"; then
    echo ">>> Re-entering active Pilot seat..."
    podman exec -it "lab-$PROJECT" /bin/bash
else
    echo ">>> Pilot seat is cold. Igniting via opencode.sh..."
    bash ~/lab/labs/opencode.sh
fi