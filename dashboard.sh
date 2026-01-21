#!/usr/bin/env bash
# ~/lab/dashboard.sh - The Central Command Center

CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
AMBER='\033[38;5;214m'
NC='\033[0m'

# 1. Gather Intelligence
POD_STATUS=$(podman inspect -f '{{.State.Running}}' lab-alpha 2>/dev/null || echo "false")
# Detect which project is currently mounted
CURRENT_PROJ=$(lsblk -no MOUNTPOINT,SOURCE | grep "$HOME/lab/mnt/workspace" | awk '{print $2}' | xargs basename 2>/dev/null | sed 's/_ws.img//')
[[ -z "$CURRENT_PROJ" ]] && CURRENT_PROJ="NONE"

clear
echo -e "${AMBER}=== SOVEREIGN COMMAND HUD ===${NC}"
echo -e "ACTIVE PROJECT: [${CYAN}${CURRENT_PROJ}${NC}]"
echo -e "POD STATUS:     [$( [[ "$POD_STATUS" == "true" ]] && echo -e "${GREEN}ONLINE${NC}" || echo -e "${RED}OFFLINE${NC}" )]"
echo "-----------------------------------"

# 2. Command Menu
options=(
    "🚀 IGNITE  - Launch Opencode (Hardened)"
    "⚒️  FORGE   - Create New Project Pair"
    "🔌 TOGGLE  - Switch Active Project"
    "👁️  OBSERVE - Start Signal Listener"
    "📦 NOTARY  - Sync Brain to Museum"
    "❄️  FREEZE  - Manual MD Snapshot"
    "🩹 REPAIR  - Force Pilot Permissions"
    "🧹 CLEAN   - Unmount & Kill Everything"
    "🚪 EXIT"
)

# Use fzf for the selection
choice=$(printf "%s\n" "${options[@]}" | fzf --prompt="Action > " --height=15 --layout=reverse --border --info=hidden)

case "$choice" in
    *"IGNITE"*)  bash ~/lab/labs/opencode.sh ;;
    *"FORGE"*)   bash ~/lab/tools/forge.sh new ;;
    *"TOGGLE"*)  bash ~/lab/tools/forge.sh toggle ;;
    *"OBSERVE"*) tmux new-window -n "Observer" "bash ~/lab/diag/observer.sh" ;;
    *"NOTARY"*)  bash ~/lab/tools/notary_sync.sh ;;
    *"FREEZE"*)  bash ~/lab/tools/mdfridge.sh ;;
    *"REPAIR"*)  sudo chown -R 1000:1000 ~/lab/mnt/workspace ~/lab/mnt/brain && echo "Repaired." && sleep 1 ;;
    *"CLEAN"*)   
        podman stop lab-alpha 2>/dev/null
        bash ~/lab/tools/forge.sh clean
        echo "Lab Zeroed." && sleep 1 ;;
    *"EXIT"*)    exit 0 ;;
esac

# Auto-reload the dashboard after a command finishes (unless exiting)
exec "$0"