#!/usr/bin/env bash
# ~/lab/tools/fridge/dotfridge.sh

FILE=$1
if [[ -z "$FILE" || ! -f "$FILE" ]]; then
    echo "Usage: dotfridge <filename>"
    exit 1
fi

# Extraction of path and ext for the house-standard naming
FILENAME=$(basename "$FILE")
EXTENSION="${FILENAME##*.}"
# Handle extensionless cases specifically
if [[ "$FILENAME" == "$EXTENSION" ]]; then EXTENSION="noext"; fi

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
# The silo: .fridge/filename_ext/
SILO_DIR="./.fridge/${FILENAME}_${EXTENSION}"

mkdir -p "$SILO_DIR"
cp "$FILE" "$SILO_DIR/${FILENAME}.${TIMESTAMP}.snack"

echo "❄️ [Classic] Fridged $FILENAME to $SILO_DIR"