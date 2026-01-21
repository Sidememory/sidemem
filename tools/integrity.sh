#!/usr/bin/env bash
# ~/lab/diag/integrity.sh

CARTRIDGE_DIR="$HOME/lab/cartridges"
MNT_WS="$HOME/lab/mnt/workspace"

echo ">>> SOVEREIGN INTEGRITY AUDIT"

if mountpoint -q "$MNT_WS"; then
    echo "[!] Error: Bridge is active. Eject cartridges before running integrity check."
    exit 1
fi

for img in "$CARTRIDGE_DIR"/*.img; do
    echo "--- Checking: $(basename "$img") ---"
    # -n performs a non-destructive read-only check
    sudo e2fsck -n "$img"
done

echo ">>> Audit Complete."