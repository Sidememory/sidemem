#!/usr/bin/env bash
# Run this inside the pod: /usr/local/bin/tools/fridge/auto-fridge.sh

WATCH_PATH="/home/pilot/workspace"

echo "❄️ Auto-Fridge Active: Watching for changes..."

inotifywait -m -r -e close_write --format '%w%f' "$WATCH_PATH" | while read FILE
do
    # Ignore the .fridge directory itself to prevent infinite loops
    if [[ "$FILE" != *"/.fridge/"* ]]; then
        bash /usr/local/bin/tools/fridge/dotfridge.sh "$FILE"
    fi
done