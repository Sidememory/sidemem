#!/usr/bin/env bash
# ~/lab/diag/perms.sh - Sovereign Discovery & Audit

AMBER='\033[38;5;214m'
RESET='\033[0m'
LAB_DIR="$HOME/lab"
CARTRIDGE_DIR="$LAB_DIR/cartridges"
MNT_WS="$LAB_DIR/mnt/workspace"
MNT_BR="$LAB_DIR/mnt/brain"

echo -e "${AMBER}🔍 SOVEREIGN DISCOVERY & PERM AUDIT${RESET}"
echo "------------------------------------------"

# 1. Discover Available Cartridges
echo -e "${AMBER}📦 Available Cartridges on Disk:${RESET}"
PROJECTS=($(ls "$CARTRIDGE_DIR" | grep "_ws.img" | sed 's/_ws.img//'))

if [ ${#PROJECTS[@]} -eq 0 ]; then
    echo "  ❌ No cartridges found in $CARTRIDGE_DIR"
else
    for p in "${PROJECTS[@]}"; do
        WS_SIZE=$(du -h "$CARTRIDGE_DIR/${p}_ws.img" | cut -f1)
        BR_SIZE=$(du -h "$CARTRIDGE_DIR/${p}_brain.img" | cut -f1)
        echo -e "  • ${AMBER}$p${RESET} (WS: $WS_SIZE | BR: $BR_SIZE)"
    done
fi

echo ""

# 2. Audit Active Bridges
echo -e "${AMBER}🌉 Active Bridge Status:${RESET}"
for dir in "$MNT_WS" "$MNT_BR"; do
    if mountpoint -q "$dir"; then
        # Check for 1000:1000 (The Pilot's Seat)
        PERMS=$(stat -c "%u:%g" "$dir")
        MODE=$(stat -c "%a" "$dir")
        
        if [[ "$PERMS" == "1000:1000" ]]; then
            echo -e "  ✅ $dir -> ${AMBER}CONNECTED${RESET} (Pilot Ready: $MODE)"
        else
            echo -e "  ⚠️  $dir -> ${AMBER}LOCKED${RESET} (Owned by $PERMS - Needs Chown)"
        fi
    else
        echo "  ⚪ $dir -> DISCONNECTED"
    fi
done

# 3. Check for Orphaned Loop Devices
ORPHANS=$(losetup -a | grep -E "ws.img|brain.img")
if [[ -n "$ORPHANS" ]]; then
    echo -e "\n${AMBER}🖇️  System Loop Devices:${RESET}"
    echo "$ORPHANS"
fi