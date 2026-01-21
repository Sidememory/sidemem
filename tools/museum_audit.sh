#!/usr/bin/env bash
# ~/lab/diag/museum_audit.sh

MUSEUM="$HOME/lab/mnt/brain/museum"

echo "🏛️  SOVEREIGN MUSEUM CURATOR"
echo "---------------------------"

if [ ! -d "$MUSEUM" ]; then
    echo "Museum is currently empty."
    exit 0
fi

# List artifacts by date, oldest first
ls -ltr "$MUSEUM" | awk '{print $6, $7, $8, " - ", $9}'

echo ""
read -p "Would you like to inspect an artifact (name) or exit? " ARTIFACT
if [ -n "$ARTIFACT" ] && [ -f "$MNT_WS/$ARTIFACT" ]; then
    # Open in read-only mode (view)
    less "$MUSEUM/$ARTIFACT"
fi