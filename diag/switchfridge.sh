#!/usr/bin/env bash
# ~/lab/tools/switchfridge_receiver.sh
# Run this to wait for a file "pushed" from the pod.

PORT=9999
MNT_BR="$HOME/lab/mnt/brain/mailbox"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo ">>> Sovereign Switch: Waiting for incoming data on port $PORT..."
nc -l -p $PORT > "$MNT_BR/network_snack_$TIMESTAMP.bin"
echo ">>> Transfer received and stored in Brain."