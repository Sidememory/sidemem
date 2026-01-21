#!/usr/bin/env bash
# ~/lab/diag/expand_cartridge.sh

IMG_PATH=$1
NEW_SIZE=$2 # e.g. 2G

if [[ -z "$IMG_PATH" || -z "$NEW_SIZE" ]]; then
    echo "Usage: expand_cartridge <path_to_img> <new_size_in_G>"
    exit 1
fi

echo ">>> Expanding $IMG_PATH to $NEW_SIZE..."

# 1. Expand the physical file
truncate -s "$NEW_SIZE" "$IMG_PATH"

# 2. Resize the internal filesystem
# We use e2fsck first to ensure it's clean
sudo e2fsck -f "$IMG_PATH"
sudo resize2fs "$IMG_PATH"

echo ">>> Expansion complete. Artifacts preserved."