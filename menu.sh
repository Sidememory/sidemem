#!/usr/bin/env bash
# ~/lab/menu.sh - The Sovereign Front Door

AMBER='\033[38;5;214m'
RESET='\033[0m'

echo -e "${AMBER}--- SOVEREIGN LAB: MAIN TERMINAL ---${RESET}"

options=(
    "🔭 Discovery Engine (lab-menu.sh)"
    "🚀 Resume Alpha Project (Quick Launch)"
    "🛠️ Lab Maintenance (Diag/Clean)"
    "   Rebuild Opencode Pod"
    "🚪 Exit"
)

select opt in "${options[@]}"; do
    case $REPLY in
        1) bash ~/lab/lab-menu.sh ; break ;;
        2) bash ~/lab/labs/opencode.sh alpha ; break ;;
        3) 
            echo -e "${AMBER}Running Diag Suite...${RESET}"
            bash ~/lab/diag/audit_bridge.sh
            break ;;
        4) podman build -t localhost/opencode-agent -f ~/lab/opencode.dockerfile ~/lab ; break ;; 
        5) exit 0 ;;
        *) echo "Invalid option $REPLY" ;;
    esac
done