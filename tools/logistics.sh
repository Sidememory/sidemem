#!/usr/bin/env bash
# Dispatched via the Signal-Disc
COMMAND=$1
SIGNAL_DIR="/home/pilot/workspace/.signals"

if [ -z "$COMMAND" ]; then
    echo "Commands: FREEZE (Snapshot), NOTARY (Archive), MIRROR (SSD Backup)"
    exit 1
fi

mkdir -p "$SIGNAL_DIR"
touch "$SIGNAL_DIR/$COMMAND"
echo "[Logistics] Signal '$COMMAND' sent to the Observer."