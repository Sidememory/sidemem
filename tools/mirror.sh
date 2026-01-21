#!/usr/bin/env bash
# ~/lab/tools/mirror.sh

MNT_WS="$HOME/lab/mnt/workspace"
MIRROR_DIR="$HOME/lab/backups/workspace_mirror"

mkdir -p "$MIRROR_DIR"

if ! mountpoint -q "$MNT_WS"; then
    echo "[!] Error: Workspace not bridged. Cannot mirror."
    exit 1
fi

echo ">>> Mirroring Workspace to Host Storage..."
# --delete ensures the mirror is an exact copy (removes what you deleted)
rsync -av --delete --exclude '.fridge' "$MNT_WS/" "$MIRROR_DIR/"

echo ">>> Mirror Updated at $MIRROR_DIR"