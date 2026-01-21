#!/usr/bin/env bash
# ~/lab/diag/eject.sh

MNT_WS="$HOME/lab/mnt/workspace"
MNT_BR="$HOME/lab/mnt/brain"

echo ">>> Terminating all Lab Containers..."
podman stop $(podman ps -q --filter name=lab-) 2>/dev/null

echo ">>> Ejecting Cartridges..."
sudo umount "$MNT_WS" "$MNT_BR" && echo "Done." || echo "Device busy - check other windows."