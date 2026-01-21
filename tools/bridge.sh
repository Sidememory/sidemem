#!/usr/bin/env bash
# ~/lab/tools/bridge.sh

ACTION=$1   # 'up' (mount to host), 'down' (unmount), 'status'
PROJECT=$2  # e.g., 'alpha'

MNT_WS="$HOME/lab/mnt/workspace"
MNT_BR="$HOME/lab/mnt/brain"
IMG_WS="$HOME/lab/cartridges/${PROJECT}_ws.img"
IMG_BR="$HOME/lab/cartridges/${PROJECT}_brain.img"

function mount_host() {
    echo ">>> Connecting Bridge for project [$PROJECT]..."
    sudo mkdir -p "$MNT_WS" "$MNT_BR"
    
    # Mount to host
    sudo mount -o loop "$IMG_WS" "$MNT_WS"
    sudo mount -o loop "$IMG_BR" "$MNT_BR"
    
    # Hand over keys to UID 1000
    sudo chown -R 1000:1000 "$MNT_WS" "$MNT_BR"
    echo "✅ Drives visible at ~/lab/mnt/"
}

function unmount_host() {
    echo ">>> Severing Bridge for project [$PROJECT]..."
    sudo umount "$MNT_WS" 2>/dev/null
    sudo umount "$MNT_BR" 2>/dev/null
    echo "✅ Host detached. Drives ready for Podman."
}

case $ACTION in
    up) mount_host ;;
    down) unmount_host ;;
    status) mountpoint -q "$MNT_WS" && echo "Status: ATTACHED" || echo "Status: DETACHED" ;;
    *) echo "Usage: bridge [up|down|status] [project_name]" ;;
esac