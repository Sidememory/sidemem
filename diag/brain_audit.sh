#!/usr/bin/env bash
# ~/lab/diag/brain_audit.sh

MNT_BR="$HOME/lab/mnt/brain"
AMBER='\033[38;5;214m'
RESET='\033[0m'

echo -e "${AMBER}🧠 BRAIN ANALYTICS${RESET}"

if ! mountpoint -q "$MNT_BR"; then
    echo "Error: Brain is not connected."
    exit 1
fi

echo -e "\n${AMBER}Current Snapshots in Mailbox:${RESET}"
ls -lh "$MNT_BR/mailbox" | grep ".md" || echo "  (No snapshots found)"

echo -e "\n${AMBER}Brain Capacity:${RESET}"
df -h "$MNT_BR" | awk 'NR==2 {print "  Used: " $3 " / " $2 " (" $5 ")"}'

echo -e "\n${AMBER}Recent Transitions:${RESET}"
tail -n 5 "$MNT_BR/mailbox/session.log" 2>/dev/null || echo "  (No log found)"