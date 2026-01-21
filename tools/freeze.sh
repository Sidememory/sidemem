#!/usr/bin/env bash
# ~/lab/tools/freeze.sh - The Sovereign Snack Manager

MODE=$1    # -m (MD), -c (Clipboard), -z (Zip)
PROJECT=$2
WS_ROOT="/home/pilot/workspace" 

# --- RUGGED FILTERS ---
# We ignore .img files and internal hidden metadata to avoid recursive bloat.
EXCLUDE_PATTERN=".*\.img$"

generate_md() {
    # 1. Directories (Trailing Slash)
    find "$WS_ROOT" -type d -not -path '*/.*' | while read -r dir; do
        rel_dir="./${dir#$WS_ROOT/}/"
        [[ "$rel_dir" == "././" ]] && continue
        echo "---"
        echo "ext filepath=\"$rel_dir\""
        echo "---"
        echo ""
    done

    # 2. Files (House-Standard Tagging)
    find "$WS_ROOT" -type f -not -regex "$EXCLUDE_PATTERN" -not -path '*/.*' | while read -r file; do
        rel_file="./${file#$WS_ROOT/}"
        filename=$(basename "$file")
        
        # Determine Language Tag
        if [[ "$filename" == .* ]]; then
            lang="dotfile"
        elif [[ "$filename" != *.* ]]; then
            lang="" # Extensionless: No tag
        else
            lang="${filename##*.}"
        fi

        echo "---"
        echo "**\`$rel_file\`**"
        echo ""
        echo "\`\`\`$lang filepath=\"$rel_file\""
        [[ -s "$file" ]] && cat "$file"
        echo "\`\`\`"
        echo "---"
        echo ""
    done
}

case $MODE in
    -m) generate_md > "/home/pilot/brain/${PROJECT}_$(date +%Y%m%d).md" ;;
    -c) generate_md | powershell.exe -Command "Set-Clipboard" ;;
    -z) zip -r "/home/pilot/brain/${PROJECT}_backup.zip" "$WS_ROOT" -x "*.img" ;;
    *) echo "Usage: freeze [-m|-c|-z] prefix" ;;
esac
