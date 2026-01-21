#!/usr/bin/env bash
# ~/lab/labs/opencode.sh

MNT_WS="$HOME/lab/mnt/workspace"
MNT_BR="$HOME/lab/mnt/brain"

# 1. UNIVERSAL DETECTION: Check the filesystem mount table
# This is much more reliable across different Linux distros
if mountpoint -q "$MNT_WS"; then
    # Get the source device and find which image it belongs to
    DEVICE=$(mount | grep "$MNT_WS" | awk '{print $1}')
    PROJECT=$(lsblk -no LABEL,NAME "$DEVICE" 2>/dev/null | grep "_ws" | sed 's/_ws//')
    
    # If LABEL fails, we fallback to the project name passed as a flag
    PROJECT=${PROJECT:-$1}
else
    PROJECT=$1
fi

# 2. FINAL VERIFICATION
if [ -z "$PROJECT" ]; then
    echo "⚠️ No project detected at $MNT_WS."
    echo "Please ensure you have Toggled a pair first."
    exit 1
fi

echo -e "\033[0;32m🚀 Igniting Hardened Lab: [$PROJECT]\033[0m"

# 3. LAUNCH
podman run -it --rm \
    --replace \
    --name "lab-alpha" \
    --user 1000:1000 \
    --userns=keep-id \
    --read-only \
    --tmpfs /tmp:rw,size=128m,mode=1777 \
    --tmpfs /home/pilot/.cache:rw,size=256m,mode=1777 \
    -v "$MNT_WS:/home/pilot/workspace:z" \
    -v "$MNT_BR:/home/pilot/brain:z" \
    -v "$HOME/lab/tools:/home/pilot/signal:ro,z" \
    --workdir /home/pilot/workspace \
    localhost/opencode-agent