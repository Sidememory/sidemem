#!/usr/bin/env bash
# ~/lab/tools/fridge.sh

FILE=$1
if [[ -z "$FILE" || ! -f "$FILE" ]]; then
    echo "Usage: fridge <file>"
    exit 1
fi

FILENAME=$(basename "$FILE")
EXT="${FILENAME##*.}"
[[ "$FILENAME" == "$EXT" ]] && EXT="noext"

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
# Create .fridge relative to the file's current location
DIR=$(dirname "$FILE")
SILO="$DIR/.fridge/${FILENAME}_${EXT}"

mkdir -p "$SILO"
cp "$FILE" "$SILO/${FILENAME}.${TIMESTAMP}.snack"

echo "[Classic] Fridged: $FILENAME -> $SILO"