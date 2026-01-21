#!/usr/bin/env bash
# ~/lab/labs/caddy-shell.sh

MNT_WS="$HOME/lab/mnt/workspace"

if ! mountpoint -q "$MNT_WS"; then
    echo "Error: No active bridge. Run opencode.sh first."
    exit 1
fi

echo ">>> Entering as CADDY (Restricted)..."
# Start a pod as a different user to test permissions
podman run -it --rm \
    --user 1001:1001 \
    -v "$MNT_WS:/home/caddy/workspace:z" \
    alpine sh -c "ls -la /home/caddy/workspace && touch /home/caddy/workspace/caddy_test.txt"