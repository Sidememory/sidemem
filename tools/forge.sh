#!/usr/bin/env bash
# ~/lab/tools/forge.sh - Smart Pair Management & DNA Provisioning

CARTRIDGE_DIR="$HOME/lab/cartridges"
MNT_WS="$HOME/lab/mnt/workspace"
MNT_BR="$HOME/lab/mnt/brain"
TEMP_MNT="/tmp/forge_mnt"

# Ensure directories exist
mkdir -p "$CARTRIDGE_DIR" "$MNT_WS" "$MNT_BR"

# --- HELPER FUNCTIONS ---

# Injects the folder structure Opencode needs before the system goes Read-Only
provision_brain() {
    local img_path=$1
    echo "🧠 Injecting DNA into Brain Cartridge..."
    mkdir -p "$TEMP_MNT"
    
    sudo mount -o loop "$img_path" "$TEMP_MNT"
    
    # Create the internal hierarchy
    sudo mkdir -p "$TEMP_MNT/.local/share/opencode/log"
    sudo mkdir -p "$TEMP_MNT/.config"
    sudo mkdir -p "$TEMP_MNT/.cache"
    sudo mkdir -p "$TEMP_MNT/museum"
    
    # Set permissions for Pilot (UID 1000)
    sudo chown -R 1000:1000 "$TEMP_MNT"
    sudo chmod -R 775 "$TEMP_MNT"
    
    sudo umount "$TEMP_MNT"
    echo "✅ DNA Injected. Permissions locked to Pilot (1000)."
}

# Prompt for input if arguments are missing
get_input() {
    local prompt_msg=$1
    local var_name=$2
    local default_val=$3
    if [ -z "${!var_name}" ]; then
        read -p "$prompt_msg [$default_val]: " input_val
        eval "$var_name=\"${input_val:-$default_val}\""
    fi
}

# --- MAIN MENU LOGIC ---

if [ -z "$1" ]; then
    echo -e "\n--- ⚒️  SOVEREIGN FORGE ---"
    echo "1) NEW    - Create a fresh project pair"
    echo "2) TOGGLE - Switch the bridge to a project"
    echo "3) CLEAN  - Unmount and disconnect bridge"
    read -p "Selection [1-3]: " cmd_choice
    case $cmd_choice in
        1) COMMAND="new" ;;
        2) COMMAND="toggle" ;;
        3) COMMAND="clean" ;;
        *) echo "Exit."; exit 0 ;;
    esac
else
    COMMAND=$1
fi

# --- COMMAND EXECUTION ---

case $COMMAND in
    "new")
        PROJECT=$2; SIZE=$3
        get_input "Project Name" PROJECT "powercake"
        get_input "Storage Size (e.g., 100M, 1G)" SIZE "1000M"
        
        echo "⚒️  Forging [${PROJECT}]..."
        truncate -s "$SIZE" "$CARTRIDGE_DIR/${PROJECT}_ws.img"
        truncate -s "$SIZE" "$CARTRIDGE_DIR/${PROJECT}_brain.img"
        
        mkfs.ext4 -F "$CARTRIDGE_DIR/${PROJECT}_ws.img" > /dev/null
        mkfs.ext4 -F "$CARTRIDGE_DIR/${PROJECT}_brain.img" > /dev/null
        
        provision_brain "$CARTRIDGE_DIR/${PROJECT}_brain.img"
        echo "✨ Project [${PROJECT}] is ready for toggle."
        ;;

    "toggle")
        PROJECT=$2
        if [ -z "$PROJECT" ]; then
            echo "Available Cartridges:"
            ls "$CARTRIDGE_DIR" | grep "_ws.img" | sed 's/_ws.img//'
            read -p "Switch to project: " PROJECT
        fi
        
        echo "🔌 Toggling Bridge to [${PROJECT}]..."
        sudo umount "$MNT_WS" "$MNT_BR" 2>/dev/null
        
        sudo mount -o loop "$CARTRIDGE_DIR/${PROJECT}_ws.img" "$MNT_WS"
        sudo mount -o loop "$CARTRIDGE_DIR/${PROJECT}_brain.img" "$MNT_BR"
        
        sudo chown -R 1000:1000 "$MNT_WS" "$MNT_BR"
        echo "✅ Bridge Active. Files visible at ~/lab/mnt/"
        ;;

    "clean")
        sudo umount "$MNT_WS" "$MNT_BR" 2>/dev/null
        echo "✅ Bridge Severed."
        ;;
esac