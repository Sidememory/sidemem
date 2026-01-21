#!/usr/bin/env bash
# ~/lab/sovereign.sh - Discovery-based Lab Orchestrator (With Visibility)

AMBER='\033[38;5;214m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

# --- NEW: Error Handler Wrapper ---
# This ensures if a script crashes, it pauses so you can actually read the error.
execute_action() {
    echo -e "${CYAN}▶ Executing: $@${NC}"
    "$@"
    local exit_code=$?
    
    if [ $exit_code -ne 0 ]; then
        echo -e "\n${RED}🛑 ERROR: Action failed (Exit Code: $exit_code)${NC}"
        read -p "Press [Enter] to return to menu..."
    fi
}

# --- THE SELECTOR ---
function discover_and_select() {
    local projects=$(ls "$HOME/lab/cartridges" 2>/dev/null | grep "_ws.img" | sed 's/_ws.img//')
    
    if [ -z "$projects" ]; then
        echo -e "${RED}❌ No projects found in cartridges/.${NC}"
        read -p "Press [Enter] to continue..."
        return 1
    fi

    echo "$projects" | fzf --prompt="Select Project Pair > " --height=10 --reverse --border
}

# --- THE MAIN MENU ---
function main_menu() {
    clear
    echo -e "${AMBER}⚡ SOVEREIGN LAB ORCHESTRATOR ⚡${NC}"
    echo "------------------------------------"

    options=(
        "🚀 IGNITE  - Select Pair & Launch Pod"
        "⚒️  FORGE   - Create New Pair"
        "🩹 REPAIR  - Select Pair & Inject DNA"
        "🔌 TOGGLE  - Just Mount/Switch a Pair"
        "🧹 CLEAN   - Unmount All & Stop Pod"
        "🚪 EXIT"
    )

    choice=$(printf "%s\n" "${options[@]}" | fzf --prompt="Action > " --height=12 --layout=reverse --border)

    case "$choice" in
        *"IGNITE"*)
            PROJECT=$(discover_and_select)
            if [ ! -z "$PROJECT" ]; then
                # 1. Mount the disks
                execute_action bash ~/lab/tools/forge.sh toggle "$PROJECT"
                
                # 2. Safety Check: If DNA is missing, run Repair automatically
                if [ ! -d "$HOME/lab/mnt/brain/.opencode" ]; then
                    echo "🧬 New pair detected. Injecting DNA..."
                    execute_action bash ~/lab/tools/init-project.sh "$PROJECT"
                fi
                
                # 3. Launch
                execute_action bash ~/lab/labs/opencode.sh "$PROJECT"
            fi
            ;;
        *"FORGE"*)
            execute_action bash ~/lab/tools/forge.sh new
            ;;
        *"REPAIR"*)
            PROJECT=$(discover_and_select)
            [ ! -z "$PROJECT" ] && execute_action bash ~/lab/tools/init-project.sh "$PROJECT"
            ;;
        *"TOGGLE"*)
            PROJECT=$(discover_and_select)
            [ ! -z "$PROJECT" ] && execute_action bash ~/lab/tools/forge.sh toggle "$PROJECT"
            ;;
        *"CLEAN"*)
            execute_action podman stop lab-alpha
            execute_action bash ~/lab/tools/forge.sh clean
            ;;
        *"EXIT"*) exit 0 ;;
    esac
}

while true; do main_menu; done















