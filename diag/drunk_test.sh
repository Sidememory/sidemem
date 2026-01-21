#!/usr/bin/env bash
# ~/lab/diag/drunk_test.sh

WS_DIR="$HOME/lab/mnt/workspace"
echo "🧪 [DIAG] STARTING DRUNK AGENT SIMULATION"

# Create a 'Director Protected' file
sudo touch "$WS_DIR/director_only.lock"
sudo chmod 600 "$WS_DIR/director_only.lock"

echo ">>> Attempting unauthorized write as Pilot (UID 1000)..."
sudo -u #1000 -g #1000 bash -c "echo 'bad data' > $WS_DIR/director_only.lock" 2>/dev/null \
    && echo "❌ FAILURE: Pilot breached Director file!" \
    || echo "✅ SUCCESS: Permission Railguard held."

# Cleanup
sudo rm "$WS_DIR/director_only.lock"