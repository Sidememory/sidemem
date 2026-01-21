#!/usr/bin/env bash
# ~/lab/diag/cleanup.sh - Force Reset Bridge

echo "[!] Attempting Force Unmount..."
sudo umount -f ~/lab/mnt/workspace 2>/dev/null
sudo umount -f ~/lab/mnt/brain 2>/dev/null

echo "[!] Detaching Zombie Loop Devices..."
# This finds any loops pointing to your lab and kills them
for dev in $(losetup -a | grep "lab/cartridges" | cut -d: -f1); do
    sudo losetup -d "$dev"
    echo "Done: $dev"
done

echo "[!] Cleanup Complete."