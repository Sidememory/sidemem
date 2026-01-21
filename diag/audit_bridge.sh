#!/usr/bin/env bash
# Checks if the loopback mounts are actually writable by the user
MNT_WS="$HOME/lab/mnt/workspace"

echo "🔍 Auditing Workspace Bridge..."
if [ -w "$MNT_WS" ]; then
    echo "✅ Workspace is Writable."
else
    echo "❌ Workspace is READ-ONLY or owned by Root."
    echo "   Suggestion: sudo chown 1000:1000 $MNT_WS"
fi

# Check for "Zombie" mounts (images deleted but still mounted)
findmnt -D | grep "loop"