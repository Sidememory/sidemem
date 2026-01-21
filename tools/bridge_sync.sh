#!/usr/bin/env bash
# ~/lab/tools/bridge_sync.sh

MAILBOX="$HOME/lab/mnt/brain/mailbox"
ARCHIVE="$HOME/lab/mnt/brain/archive"

mkdir -p "$ARCHIVE"

echo ">>> Escrow: Moving exports from Mailbox to Archive..."

# Move only .md or .txt files to prevent the Agent from sneaking in binaries
find "$MAILBOX" -maxdepth 1 -type f \( -name "*.md" -o -name "*.txt" \) | while read -r file; do
    # Remove executable bits for security
    chmod -x "$file"
    mv "$file" "$ARCHIVE/"
    echo "  [+] Verified & Archived: $(basename "$file")"
done

echo ">>> Escrow Complete."