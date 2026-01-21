#!/usr/bin/env bash
# ~/lab/labs/director-shell.sh

MNT_WS="$HOME/lab/mnt/workspace"
export PATH="$PATH:$HOME/lab/tools:$HOME/lab/diag"

if ! mountpoint -q "$MNT_WS"; then
    echo "[!] Error: No active bridge. Please ignite a project first."
    exit 1
fi

echo ">>> DIRECTOR SHELL ACTIVE"
echo ">>> Tools available: fridge, mdfridge, mirror, eject"
cd "$MNT_WS"
bash --rcfile <(echo "PS1='(Director) \w\$ '")