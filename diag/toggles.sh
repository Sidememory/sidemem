#!/usr/bin/env bash
# ~/lab/diag/toggles.sh

SHED_CFG="$HOME/lab/.shed/bash/toggles.cfg"
mkdir -p "$(dirname "$SHED_CFG")"

# Initialize if missing
if [ ! -f "$SHED_CFG" ]; then
    echo "LAB_HANDSHAKE_ACTIVE=false" > "$SHED_CFG"
    echo "LAB_CURRENT_PROJECT=\"alpha\"" >> "$SHED_CFG"
fi

# Load current state
source "$SHED_CFG"

echo "--- [DIAG] SYSTEM TOGGLES ---"
echo "1) Handshake Listener: $LAB_HANDSHAKE_ACTIVE"
echo "2) Active Project: $LAB_CURRENT_PROJECT"
echo "3) Strict Permissions: $LAB_PERMISSION_STRICT"
read -p "Selection to flip/change: " OPT

case $OPT in
    1)
        if [ "$LAB_HANDSHAKE_ACTIVE" = "true" ]; then
            sed -i 's/LAB_HANDSHAKE_ACTIVE=true/LAB_HANDSHAKE_ACTIVE=false/' "$SHED_CFG"
            pkill -f handshake_listener.sh && echo "Listener Killed."
        else
            sed -i 's/LAB_HANDSHAKE_ACTIVE=false/LAB_HANDSHAKE_ACTIVE=true/' "$SHED_CFG"
            bash "$HOME/lab/tools/handshake_listener.sh" &
            echo "Listener Sparked in Background."
        fi
        ;;
    2)
        read -p "New Project Name: " NP
        sed -i "s/LAB_CURRENT_PROJECT=.*/LAB_CURRENT_PROJECT=\"$NP\"/" "$SHED_CFG"
        ;;
    3)
        [[ "$LAB_PERMISSION_STRICT" == "true" ]] && VAL="false" || VAL="true"
        sed -i "s/LAB_PERMISSION_STRICT=.*/LAB_PERMISSION_STRICT=$VAL/" "$SHED_CFG"
        echo "Strict Mode now: $VAL"
        ;;
esac