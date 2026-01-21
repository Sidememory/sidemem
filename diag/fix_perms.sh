#!/usr/bin/env bash
# ~/lab/diag/fix_perms.sh

MNT_WS="$HOME/lab/mnt/workspace"
MNT_BR="$HOME/lab/mnt/brain"

echo "🛡️  Director: Enforcing Circle of Trust..."

# 1. Ensure the mount points themselves are owned by you
sudo chown 1000:1000 "$MNT_WS" "$MNT_BR"

# 2. Set the 'Setgid' bit so all new files inherit the project group
sudo chmod -R 2775 "$MNT_WS" "$MNT_BR"

# 3. Specifically fix the "Brain" for exports
sudo chmod 777 "$MNT_BR" # Give the Agent a "Mailbox" it can definitely write to