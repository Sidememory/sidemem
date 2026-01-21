#!/usr/bin/env bash
# ~/lab/diag/trust_audit.sh

MNT_WS="$HOME/lab/mnt/workspace"

echo "🛡️  Checking for suspicious executable bits in Workspace..."
# Find files owned by Pilot (1000) that are executable
SUSPECTS=$(find "$MNT_WS" -type f -executable -user 1000)

if [ -z "$SUSPECTS" ]; then
    echo "✅ No suspicious executables found."
else
    echo "⚠️  WARNING: Suspicious files found:"
    echo "$SUSPECTS"
    echo "Run 'chmod -x' on these to secure the perimeter."
fi