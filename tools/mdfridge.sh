#!/usr/bin/env bash
# ~/lab/tools/mdfridge.sh

MNT_WS="$HOME/lab/mnt/workspace"
MNT_BR="$HOME/lab/mnt/brain"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
OUTPUT="$MNT_BR/mailbox/state_freeze_${TIMESTAMP}.md"

echo "🧊 Sovereign Freeze in progress..."

{
    echo "# SOVEREIGN STATE FREEZE"
    echo "Date: $(date)"
    echo "---"
    
    find "$MNT_WS" -maxdepth 2 -not -path '*/.*' -type f | while read -r file; do
        REL_PATH="./${file#$MNT_WS/}"
        # Extract extension or tag as 'raw'
        EXT="${file##*.}"
        [[ "$file" == *.* ]] || EXT="txt"

        echo "---"
        echo "ext filepath=\"$REL_PATH\""
        echo '```'"$EXT"
        cat "$file"
        echo -e "\n" '```'
        echo "---"
    done
} > "$OUTPUT"

echo "✅ Documented state to $OUTPUT"