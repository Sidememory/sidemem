#!/usr/bin/env bash
# ~/lab/diag/director.sh - Host-side Admin Access

MNT_WS="$HOME/lab/mnt/workspace"
MNT_BR="$HOME/lab/mnt/brain"

echo -e "\033[38;5;214m🎬 DIRECTOR OVERSEER MODE\033[0m"

if ! mountpoint -q "$MNT_WS"; then
    echo "❌ No active bridge found. Ignition required."
    exit 1
fi

echo "1) Fix Permissions (Stamp 1000:1000)"
echo "2) Explore Workspace (Ranger)"
echo "3) Manual Snapshot (Ten-Foot Pole)"
read -p "Selection: " OPT

case $OPT in
    1) sudo chown -R 1000:1000 "$MNT_WS" "$MNT_BR" && echo "✅ Ownership Restored." ;;
    2) ranger "$MNT_WS" ;;
    3) bash ~/lab/tools/mdfridge.sh ;;
esac