#!/usr/bin/env bash
# ~/lab/tools/notary_sync.sh

MAILBOX="$HOME/lab/mnt/brain/mailbox"
MUSEUM="$HOME/lab/mnt/brain/museum"

mkdir -p "$MUSEUM"

echo ">>> Notary: Certifying exports for the Museum..."

# We move the files and ensure they are read-only for history
find "$MAILBOX" -maxdepth 1 -type f -not -name ".*" | while read -r file; do
    FILENAME=$(basename "$file")
    # Move to Museum and strip write permissions (Preservation)
    mv "$file" "$MUSEUM/"
    chmod 444 "$MUSEUM/$FILENAME"
    echo "  [+] Archived in Museum: $FILENAME"
done

echo ">>> Notary process complete."